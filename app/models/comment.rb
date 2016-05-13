class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :comment, presence: true

 def check_history?
   self.history_id.blank?
 end

 def self.show_history(num)
   where("history_id IS NULL AND id =? OR history_id =? AND id != ?", num, num, num).order("id DESC").first
 end

 def self.list_comment_history(num,not_num)
   where("history_id IS NULL AND id =? XOR history_id =? AND id != ? AND id != ?",num,num,num, not_num).order("id DESC")
 end

end

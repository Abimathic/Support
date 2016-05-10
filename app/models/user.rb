class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :image, ImageUploader
  has_many :questions
  has_many :answers
  has_many :answered_questions, :source => :question, :through => :answers
  has_many :comments
  validates :firstname, :presence => true
  #validates :image, :presence => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def fullname
    "#{firstname.capitalize} #{lastname}"
  end

  def anscount
    "Answers"
  end



end

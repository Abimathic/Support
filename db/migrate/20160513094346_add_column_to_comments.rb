class AddColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :history_id, :integer
  end
end

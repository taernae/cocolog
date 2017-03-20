class ChangeCommentBodyToText < ActiveRecord::Migration
  def up
    change_column :comments, :body, :text, :limit => nil
  end

  def down
  end
end

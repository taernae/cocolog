class ChangeLogContentsToLongtext < ActiveRecord::Migration
  def up
    change_column :logs, :contents, :text, :limit => 4294967295
  end

  def down
  end
end

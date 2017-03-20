class AddOldlogviewToUsers < ActiveRecord::Migration
  def change
    add_column :users, :old_log_view, :boolean, :default => 0
  end
end

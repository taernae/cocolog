class AddDownloadableToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :downloadable, :boolean, :default => false
  end
end

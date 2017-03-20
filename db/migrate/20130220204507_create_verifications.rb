class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.references :user
      t.string :name
      t.integer :game_id
      t.boolean :approved, :default => false
    end
  end
end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author
      t.string :owner
      t.string :creator
      t.string :body
      t.integer :reply
      t.integer :log_id
      t.boolean :modpost

      t.timestamps
    end
  end
end

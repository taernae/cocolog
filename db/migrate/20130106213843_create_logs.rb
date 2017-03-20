class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :token
      t.string :title
      t.string :description
      t.string :author
      t.integer :game
      t.integer :category
      t.boolean :private
      t.text :contents
      t.integer :owner
      t.string :creator

      t.timestamps
    end
  end
end

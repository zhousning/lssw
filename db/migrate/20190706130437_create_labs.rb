class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.string :title,              null: false, default: ""
      t.text :content,              null: false, default: ""
      t.integer :order

      t.timestamps null: false
    end
  end
end

class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :title,              null: false, default: ""
      t.string :content,              null: false, default: ""
      t.integer :order

      t.timestamps null: false
    end
  end
end

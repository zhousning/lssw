class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name,              null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :homepage,              null: false, default: ""
      t.string :title,              null: false, default: ""
      t.text :intro
      t.string :level,              null: false, default: ""
      t.string :photo,              null: false, default: ""

      t.timestamps null: false
    end
  end
end

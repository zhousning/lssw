class CreateManages < ActiveRecord::Migration
  def change
    create_table :manages do |t|
      t.string :title,              null: false, default: ""
      t.string :content,              null: false, default: ""

      t.timestamps null: false
      
    end
  end
end

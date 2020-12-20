class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title,              null: false, default: ""
      t.string :content
      t.string :category,              null: false, default: ""

      t.timestamps null: false
    end
  end
end

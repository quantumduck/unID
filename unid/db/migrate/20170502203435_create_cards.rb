class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :name
      t.string :url
      t.text :description
      
      t.timestamps
    end
  end
end

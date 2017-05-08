class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :username
      t.string :name
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end

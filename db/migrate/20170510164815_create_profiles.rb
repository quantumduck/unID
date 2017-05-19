class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.belongs_to :user, foreign_key: true
      t.string :uid
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :provider
      t.string :email
      t.string :nickname
      t.text :description
      t.string :image
      t.string :url
      t.string :token
      t.boolean :expires, default: false
      t.datetime :expires_at
    end
  end
end

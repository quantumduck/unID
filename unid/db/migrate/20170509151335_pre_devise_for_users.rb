class PreDeviseForUsers < ActiveRecord::Migration[5.0]
  change_table :users do |t|
    t.remove :email, :password_digest, :temp_password
  end
end

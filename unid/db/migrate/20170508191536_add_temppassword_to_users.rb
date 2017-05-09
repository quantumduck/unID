class AddTemppasswordToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :temp_password, :string
  end
end

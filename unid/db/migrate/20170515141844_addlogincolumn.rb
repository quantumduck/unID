class Addlogincolumn < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :allow_login, :boolean, default: false
  end
end

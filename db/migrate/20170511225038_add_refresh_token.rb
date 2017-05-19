class AddRefreshToken < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :refresh_token, :string
  end
end

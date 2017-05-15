class Adsharedprofiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :shared, :boolean, default: false
  end
end

class AddPositiontoProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :position, :integer, :null => false
    add_index :profiles, [:position]
  end
end

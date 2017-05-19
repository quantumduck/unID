class ProfileIdToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :profile_id, :integer
  end
end

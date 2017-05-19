class AddImageOtherToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :image_other, :string
  end
end

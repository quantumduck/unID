class AddNetworkToProfiles < ActiveRecord::Migration[5.0]
  def change
    change_table :profiles do |t|
      t.string :network
    end
  end
end

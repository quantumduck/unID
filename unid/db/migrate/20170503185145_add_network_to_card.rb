class AddNetworkToCard < ActiveRecord::Migration[5.0]
  def change
    change_table :cards do |t|
      t.string :network  
    end
  end
end

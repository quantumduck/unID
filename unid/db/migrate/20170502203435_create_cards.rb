class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|

      t.timestamps
    end
  end
end

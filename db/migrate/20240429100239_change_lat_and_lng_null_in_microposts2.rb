class ChangeLatAndLngNullInMicroposts2 < ActiveRecord::Migration[7.0]
  def change
    change_column :microposts, :lat, :float, null: false
    change_column :microposts, :lng, :float, null: false
  end
end

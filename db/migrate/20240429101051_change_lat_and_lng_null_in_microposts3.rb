class ChangeLatAndLngNullInMicroposts3 < ActiveRecord::Migration[7.0]
  def change
    change_column :microposts, :lat, :float, null: true
    change_column :microposts, :lng, :float, null: true
  end
end

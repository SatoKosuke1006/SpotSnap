class RemoveLatAndLngFromMicroposts < ActiveRecord::Migration[7.0]
  def change
    remove_column :microposts, :lat, :float
    remove_column :microposts, :lng, :float
  end
end
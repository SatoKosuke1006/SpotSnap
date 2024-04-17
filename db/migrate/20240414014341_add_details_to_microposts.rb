class AddDetailsToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :lat, :float
    add_column :microposts, :lng, :float
  end
end

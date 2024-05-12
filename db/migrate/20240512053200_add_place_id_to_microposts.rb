class AddPlaceIdToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :place_id, :string
  end
end

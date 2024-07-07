class AddAspectRatioToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :aspect_ratio, :string
  end
end

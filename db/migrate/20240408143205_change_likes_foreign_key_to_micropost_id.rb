class ChangeLikesForeignKeyToMicropostId < ActiveRecord::Migration[7.0]
  def change
    rename_column :likes, :post_id, :micropost_id
  end
end

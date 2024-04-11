class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.integer :like_id, null: false
      t.integer :user_id, null: false
      t.integer :micropost_id, null: false
      t.datetime :created_at, null: false
    end

    add_index :likes, :like_id, unique: true
    add_index :likes, :user_id
    add_index :likes, :post_id
  end
end

class CreateFavoriteBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_books do |t|
      t.string :isbn, null: false
      t.string :title, null: false
      t.string :author
      t.string :url
      t.string :image_url
      t.string :item_caption

      t.timestamps
    end
  end
end

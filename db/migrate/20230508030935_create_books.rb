class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      
      t.string :isbn, null: false
      t.string :title, null: false
      t.string :author
      t.string :url
      t.string :image_url
      t.string :item_caption
      t.string :book_genre_id
      
      t.timestamps
      t.index [:isbn]
      t.index [:title]
    end
  end
end

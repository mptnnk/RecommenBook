class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :user_id, null: false
      t.integer :book_id
      t.text :review
      t.boolean :in_release, default: false

      t.timestamps
    end
  end
end

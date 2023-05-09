class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :user_id, null: false
      t.string :isbn
      t.text :content
      t.datetime :readed_at
      t.boolean :in_release, default: false

      t.timestamps
    end
  end
end

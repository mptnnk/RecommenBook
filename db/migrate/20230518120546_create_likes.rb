class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :review_id
      t.integer :tweet_id

      t.timestamps
    end
  end
end

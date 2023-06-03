class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets do |t|
      t.integer :user_id, null: false
      t.string :isbn
      t.text :tweet_content, null: false

      t.timestamps
    end
  end
end

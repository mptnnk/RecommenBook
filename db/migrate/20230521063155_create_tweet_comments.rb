class CreateTweetComments < ActiveRecord::Migration[6.1]
  def change
    create_table :tweet_comments do |t|
      t.integer :user_id
      t.integer :tweet_id
      t.text :comment, null: false

      t.timestamps
    end
  end
end

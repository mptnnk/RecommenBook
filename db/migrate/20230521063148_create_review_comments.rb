class CreateReviewComments < ActiveRecord::Migration[6.1]
  def change
    create_table :review_comments do |t|
      t.integer :user_id
      t.integer :review_id
      t.text :comment, null: false

      t.timestamps
    end
  end
end

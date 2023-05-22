class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :user_id, null: false
      t.string :isbn, null: false
      t.text :content, null: false
      t.datetime :readed_at
      t.boolean :in_release, default: true
      t.boolean :spoiler, default: false

      t.timestamps
    end
  end
end

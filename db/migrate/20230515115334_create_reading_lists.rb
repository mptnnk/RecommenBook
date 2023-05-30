class CreateReadingLists < ActiveRecord::Migration[6.1]
  def change
    create_table :reading_lists do |t|
      t.integer :user_id, null: false
      t.string :isbn, null: false
      t.timestamps
    end
  end
end

class CreateReadedBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :readed_books do |t|
      t.integer :user_id, null: false
      t.string :isbn, null: false
      t.datetime :readed_at
      t.timestamps
    end
  end
end

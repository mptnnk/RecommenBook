class CreateHashtagRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :hashtag_relations do |t|
      t.integer :hashtag_id
      t.integer :review_id

      t.timestamps
    end
  end
end

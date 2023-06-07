class RenameNameColumnToHashtags < ActiveRecord::Migration[6.1]
  def change
    rename_column :hashtags, :name, :hashname
  end
end

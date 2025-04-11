class DropCategoriesTables < ActiveRecord::Migration[7.1]
  def change
    drop_table :categories_tables
  end
end

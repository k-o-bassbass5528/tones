class AddStatusToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :category_id, :status, :integer, default: 0, null: false
  end
end
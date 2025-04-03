class RenameInstrumentsColumnToPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :instruments, :instrument
  end
end
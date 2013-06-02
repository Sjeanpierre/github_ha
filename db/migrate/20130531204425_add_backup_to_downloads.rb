class AddBackupToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :backup, :string
  end
end

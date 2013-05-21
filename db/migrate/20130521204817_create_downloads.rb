class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string :tag
      t.date :retrieved_at
      t.date :tagged_at
      t.references :repo

      t.timestamps
    end
    add_index :downloads, :repo_id
  end
end

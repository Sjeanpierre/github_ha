class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string  :name
      t.string  :owner
      t.string  :last_tag
      t.integer :git_repo_id
      t.integer :repo_hook_id
      t.timestamps
    end
  end
end

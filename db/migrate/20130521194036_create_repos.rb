class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name
      t.string :owner
      t.string :last_tag
      t.date :last_commit

      t.timestamps
    end
  end
end

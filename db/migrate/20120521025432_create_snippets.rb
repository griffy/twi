class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :title
      t.text :content
      t.integer :visibility
      t.references :user

      t.timestamps
    end

    add_index :snippets, :user_id
  end
end

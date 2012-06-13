class CreateTaggedSnippets < ActiveRecord::Migration
  def change
    create_table :tagged_snippets do |t|
      t.references :snippet
      t.references :tag

      t.timestamps
    end

    add_index :tagged_snippets, :snippet_id
    add_index :tagged_snippets, :tag_id
  end
end

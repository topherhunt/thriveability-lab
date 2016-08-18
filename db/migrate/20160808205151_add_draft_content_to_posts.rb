class AddDraftContentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :draft_content, :text
    rename_column :posts, :content, :published_content
  end
end

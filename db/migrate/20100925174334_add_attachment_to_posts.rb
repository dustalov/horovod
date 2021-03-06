class AddAttachmentToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :attachment_file_name, :string
    add_column :posts, :attachment_content_type, :string
    add_column :posts, :attachment_file_size, :integer
  end

  def self.down
    remove_column :posts, :attachment_file_size
    remove_column :posts, :attachment_content_type
    remove_column :posts, :attachment_file_name
  end
end

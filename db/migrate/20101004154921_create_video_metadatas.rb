class CreateVideoMetadatas < ActiveRecord::Migration
  def self.up
    create_table :video_metadatas do |t|
      t.belongs_to :video, :null => false, :unique => true

      t.string :provider_name
      t.string :title
      t.string :author_name

      t.string :thumbnail_url, :null => false
      t.integer :thumbnail_width
      t.integer :thumbnail_height
    end

    add_index :video_metadatas, :video_id, :unique => true
  end

  def self.down
    drop_table :video_metadatas
  end
end

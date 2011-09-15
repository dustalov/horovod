class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :type
      t.text :body
      t.belongs_to :user, :null => false

      t.timestamps
    end

    add_index :posts, :type
    add_index :posts, :created_at
    add_index :posts, :user_id
  end

  def self.down
    drop_table :posts
  end
end

class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.text :body, :null => false, :unique => true
      t.belongs_to :user, :null => false

      t.timestamps
    end

    add_index :news, :created_at
  end

  def self.down
    drop_table :news
  end
end

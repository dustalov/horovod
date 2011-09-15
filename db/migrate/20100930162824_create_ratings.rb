class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.belongs_to :post, :null => false
      t.belongs_to :user, :null => false
      t.integer :score, :null => false

      t.timestamps
    end

    add_index :ratings, [ :post_id, :user_id ]
  end

  def self.down
    drop_table :ratings
  end
end

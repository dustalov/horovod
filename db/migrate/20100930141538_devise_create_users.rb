class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :surname, :null => false
      t.string :name, :null => false
      t.string :squad, :null => false

      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      t.timestamps
    end

    add_index :users, [ :surname, :name, :squad ], :unique => true
    add_index :users, :email, :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end

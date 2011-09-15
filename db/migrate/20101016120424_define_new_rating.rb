class DefineNewRating < ActiveRecord::Migration
  def self.up
    Rating.delete_all('score < 4')
    remove_column :ratings, :score
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration,
      "Can't restore removed ratings"
  end
end

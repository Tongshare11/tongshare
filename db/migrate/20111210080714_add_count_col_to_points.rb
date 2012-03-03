class AddCountColToPoints < ActiveRecord::Migration
  def up
	  add_column :points, :count, :integer, :default => 0
  end

  def down
	  remove_column :points, :count
  end
end

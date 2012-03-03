class AddCountColToAccessoryPoints < ActiveRecord::Migration
  def up
	  add_column :accessory_points, :count, :integer, :default => 0
  end

  def down
	  remove_column :accessory_points, :count
  end
end

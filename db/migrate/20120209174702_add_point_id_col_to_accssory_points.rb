class AddPointIdColToAccssoryPoints < ActiveRecord::Migration
  def up
	  add_column :accessory_points, :point_id, :integer, :default => 1
  end

  def down
	  remove_column :accessory_points, :point_id
  end
end

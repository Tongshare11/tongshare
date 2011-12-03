class AddFirstSecondToEvents < ActiveRecord::Migration
  def up
	  remove_column :events, :location
	  add_column :events, :first, :string
	  add_column :events, :second, :string
  end

  def down
	  remove_column :events, :first
	  remove_column :events, :second
	  add_column :events, :location, :string
	  
  end
  
end

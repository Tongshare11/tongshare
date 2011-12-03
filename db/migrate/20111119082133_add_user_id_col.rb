class AddUserIdCol < ActiveRecord::Migration
  def up
	  add_column :events, :user_id, :string
  end

  def down
	  remove_column :events, :user_id
  end
end

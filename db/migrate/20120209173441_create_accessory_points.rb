class CreateAccessoryPoints < ActiveRecord::Migration
  def change
    create_table :accessory_points do |t|
      t.string :title

      t.timestamps
    end
  end
end

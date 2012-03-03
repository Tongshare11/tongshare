class Point < ActiveRecord::Base
	has_and_belongs_to_many :events
	has_many :accessory_points, :dependent => :destroy
end

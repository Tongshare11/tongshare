class Group < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_many :user_group_relations, :dependent => :destory
end

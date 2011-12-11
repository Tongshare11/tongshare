class Event < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :points
end

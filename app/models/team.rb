class Team < ApplicationRecord
  has_many :users

  acts_as_list
end

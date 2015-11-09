class Vote < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voteable, polymorphic: true

  validates :creator, uniqueness: {scope: :voteable, message: 'You can not vote multiple times!'}
end

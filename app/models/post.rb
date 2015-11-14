class Post < ActiveRecord::Base
  include Voteable
  include Sluggable
  before_save 'self.generate_slug(:title)'

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, :url, :description, presence: true

end

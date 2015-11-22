class Post < ActiveRecord::Base
  POSTS_PER_PAGE = 3

  include Voteable
  include Sluggable
  sluggable_column :title

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, :url, :description, presence: true

  default_scope { order ('created_at DESC')}

end

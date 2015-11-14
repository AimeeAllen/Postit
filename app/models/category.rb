class Category < ActiveRecord::Base

  include Sluggable
  before_save 'self.generate_slug(:name)'

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true, format: {with: /\A[\w' ']+\z/}

end
class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true, format: {with: /\A[\w' ']+\z/}

  def to_param
    name
  end
end
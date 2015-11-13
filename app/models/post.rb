class Post < ActiveRecord::Base
  include Voteable

  before_save :generate_slug

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, :url, :description, presence: true

  def to_param
    slug
  end

  def generate_slug
    slug_prefix = non_unique_slug
    posts_with_similar_slugs = Post.where("slug like ?", "#{slug_prefix}%")
    if !posts_with_similar_slugs.empty?
      slug_suffixes = posts_with_similar_slugs.map{|m| m.slug.split("#{slug_prefix}")[1].to_i.abs}.sort
      new_suffix = slug_suffixes[-1].next
      self.slug = "#{slug_prefix}-#{new_suffix}"
    else
      self.slug = slug_prefix
    end
  end

  def non_unique_slug
    self.title.strip.gsub(/\W/,'-').gsub(/-+/,'-').downcase
  end


end

class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  
  #BUG - lets you update with a password confirmation set and no password
  validates :password, presence: true, confirmation: true, on: :create
  validates :password, allow_blank: true, confirmation: true, on: :update

  # SLUGGING - when a named path is used, to_param is always called
  # default is to return the :id
  # user_path(@user) will now instead pass the username attribute to the URI
  def to_param
    username
  end
end

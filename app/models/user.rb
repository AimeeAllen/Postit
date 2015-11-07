class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  
  #BUG - lets you update with a password confirmation set and no password
  validates :password, presence: true, confirmation: true, on: :create
  validates :password, allow_blank: true, confirmation: true, on: :update
end
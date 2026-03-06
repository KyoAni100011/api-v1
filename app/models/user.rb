class User < ApplicationRecord
  has_secure_password

  has_many :posts
  has_many :comments
  has_many :likes

  enum :status, {
    pending: 0,
    active: 1,
    suspended: 2,
    banned: 3
  }

  enum :role, {
    user: 0,
    admin: 1,
    moderator: 2
  }
end
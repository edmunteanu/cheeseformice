class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :timeoutable, :validatable, :lockable

  enum :role, { admin: "admin", user: "user" }
end

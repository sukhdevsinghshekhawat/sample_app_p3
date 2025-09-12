class User < ApplicationRecord
  #before_save{self.email = email.downcase}
  before_save{email.downcase!}
  validates :name, presence: true , length: {maximum: 20}
  #REGEX_VALID = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  Regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 45}, format: {with: Regex}, uniqueness: true
  has_secure_password
  validates :password, length: {minimum: 5}, presence: true
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end


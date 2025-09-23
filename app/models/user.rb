class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  #before_save{self.email = email.downcase}
  before_save{email.downcase!}
  validates :name, presence: true , length: {maximum: 20}
  #REGEX_VALID = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  Regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 45}, format: {with: Regex}, uniqueness: true
  has_secure_password
  validates :password, length: {minimum: 5}, presence: true, allow_nil: true
  before_create :create_activation_digest

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end 

  def remember 
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end 

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
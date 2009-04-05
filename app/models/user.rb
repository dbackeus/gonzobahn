require 'digest/sha1'
class User < ActiveRecord::Base

  acts_as_tagger

  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  
  has_many :recordings
  has_many :comments
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_protected :crypted_password, :salt, :remember_token, :remember_token_expires_at, 
                 :activation_code, :activated_at, :state, :deleted_at
  
  concerned_with :authentication
  concerned_with :states

  def to_param
    login.downcase
  end

  def to_s
    login
  end

  def open_id?
    identity_url.present?
  end

  def avatar_url
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}.jpg?d=http://#{SITE_HOST}/images/missing_avatar.gif"
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  private
  def password_required?
    return false if identity_url.present?
    crypted_password.blank? || !password.blank?
  end
  
end

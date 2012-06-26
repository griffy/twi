class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email address")
    end
  end
end

class User < ActiveRecord::Base
  include OAuth2::Model::ResourceOwner
  # users can also be the creators of client apps
  include OAuth2::Model::ClientOwner

  attr_accessible :email, :password, :password_confirmation, :account_type
  has_secure_password

  validates :terms_of_service, :acceptance => true # virtual attribute
  validates :email, :presence => true,
            :email => true,
            :uniqueness => true
  validates :password, :presence => true,
            :length => { :within => 5..30 },
            # require it being entered twice
            :confirmation => true
  # validates :password_confirmation, :presence => true
  # we want to allow for 'premium' accounts
  validates :account_type, :presence => true,
            :numericality => { :only_integer => true }

  has_many :snippets, :dependent => :destroy
  has_many :tags, :dependent => :destroy
  
  validates_associated :snippets # is this necessary?
  validates_associated :tags # ditto

  class << self
    def authenticate(email, password)
      find_by_email(email).try(:authenticate, password)
    end
  end
end

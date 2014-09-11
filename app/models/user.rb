class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable

  has_one :account
  accepts_nested_attributes_for :account
  attr_accessible :account_attributes

  after_create :create_account

end

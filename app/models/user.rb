class User < ApplicationRecord

  has_many :transactions

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :assign_default_role

  def assign_default_role
    self.add_role(:trader) if self.roles.blank?
  end

  def approved_trader?
    self.has_role?(:approved_trader)
  end
end

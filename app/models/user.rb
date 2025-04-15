class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :mood_entries, dependent: :destroy
  has_many :emotion_entries, dependent: :destroy
  has_and_belongs_to_many :roles, join_table: 'roles_users'

  validates :email, presence: true

  def has_role?(role_name)
    roles.exists?(name: role_name)
  end

  def admin?
    roles.where(name: 'admin').exists?
  end
  
  def add_role(role_name)
    role = Role.find_or_create_by(name: role_name)
    roles << role unless roles.include?(role)
  end

  def remove_role(role_name)
    role = Role.find_by(name: role_name)
    roles.delete(role) if role
  end
end

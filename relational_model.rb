class Action < ApplicationRecord
  has_many :action_permissions, dependent: :destroy
  has_many :users, through: :action_permissions
  has_many :roles, through: :action_permissions
end

class ActionPermission < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :action
end


class Caller < ApplicationRecord
  has_secure_token :token
end


class Resource < ApplicationRecord
  has_many :resource_permissions, dependent: :destroy
  has_many :users, through: :resource_permissions
  has_many :roles, through: :resource_permissions
end


class ResourcePermission < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :resource
end


class Role < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :resource_permissions
  has_many :resources, through: :resource_permissions
  has_many :action_permissions
  has_many :actions, through: :action_permissions

  validates_uniqueness_of :name
end


class User < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :resource_permissions
  has_many :resources, through: :resource_permissions
  has_many :action_permissions
  has_many :actions, through: :action_permissions

  validates_uniqueness_of :name
end


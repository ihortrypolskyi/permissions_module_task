module Permissions

    before_action :authenticate_caller


  class << self

    def register_user(user_name = params[:user_name])
        user = User.where(name: user_name).first_or_create

        render json: user
    end


    def register_role(role = params[:role_name])
        role = Role.where(name: role_name).first_or_create

        render json: role
    end


    def assign_role_to_user(role_id = params[:role_id], user_ids = params[:user_ids])
        role = Role.find(role_id)
        role.user_ids << user_ids

        render json: { role_id: role_id, role_user_ids: role.user_ids }
    end


    def grant_permission_to_user(user_id = params[:user_id], resource_id = params[:resource_id], action_id = params[:action_id], permission_status = params[:permission_status])

      if !resource_id.nil?
        resource_permission = ResourcePermission.where(user_id: user_id, resource_id: resource_id).first_or_create(user_id: user_id, resource_id: resource_id)

        unless resource_permission.permission_status.include? permission_status
          resource_permission.update_attribute(:permission_status, resource_permission.permission_status << permission_status)
        end

      elsif !action_id.nil?
        action_permission = ActionPermission.where(user_id: user_id, action_id: action_id).first_or_create(user_id: user_id, action_id: action_id, permission_status: permission_status)
      end

      render json: resource_permission || action_permission
    end


    def grant_permission_to_role(role_id = params[:role_id], resource_id = params[:resource_id], action_id = params[:action_id], permission_status = params[:permission_status])

      if !resource_id.nil?
        resource_permission = ResourcePermission.where(role_id: role_id, resource_id: resource_id).first_or_create(role_id: role_id, resource_id: resource_id)

        unless resource_permission.permission_status.include? permission_status
          resource_permission.update_attribute(:permission_status, resource_permission.permission_status << permission_status)
        end

      elsif !action_id.nil?
        action_permission = ActionPermission.where(role_id: role_id, action_id: action_id).first_or_create(role_id: role_id, action_id: action_id, permission_status: permission_status)
      end

      render json: resource_permission || action_permission
    end


    def check_user_permission(user_id = params[:user_id], resource_id = params[:resource_id], action_id = params[:action_id])

      if !resource_id.nil?
        resource_permission = ResourcePermission.where(user_id: user_id, resource_id: resource_id).first

      elsif !action_id.nil?
        action_permission = ActionPermission.where(user_id: user_id, action_id: action_id).first
      end

      render json: { resource_id: resource_id, resource_permission_status: resource_permission_status } || { resource_id: resource_id, action_permission_status: action_permission_status }
    end


    def check_role_permission(role_id = params[:role_id], resource_id = params[:resource_id], action_id = params[:action_id])

      if !resource_id.nil?
        resource_permission = ResourcePermission.where(user_id: user_id, resource_id: resource_id).first
        resource_permission_status = resource_permission.permission_status

      elsif !action_id.nil?
        action_permission = ActionPermission.where(user_id: user_id, action_id: action_id).first
        action_permission_status = action_permission.permission_status
      end

      render json: { resource_id: resource_id, resource_permission_status: resource_permission_status } || { resource_id: resource_id, action_permission_status: action_permission_status }
    end


    private


    def authenticate_caller(token = params[:token])
      unless Caller.exists?(token: token)
        render json: "Unauthorized", status: unauthorized
        return
      end
    end


  end
end

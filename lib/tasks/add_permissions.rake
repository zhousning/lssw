namespace 'db' do
  desc "Loading all models and their methods in permissions table."
  task(:add_permissions => :environment) do
    arr = []
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /_controller/
        arr << entry.camelize.gsub('.rb', '').constantize
      end
    end

    arr.each do |controller|
      puts controller.permission
      if controller.permission
        manage_title = I18n.t(controller.controller_name + ".manage.title")
        write_permission(controller.permission, "manage", manage_title, manage_title) 
        controller.action_methods.each do |method|
          if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/
            name, cancan_action, action_desc = eval_cancan_action(controller.controller_name, method)
            write_permission(controller.permission, cancan_action, name, action_desc)  
          end
        end
      end
    end

    #如需预添加一些角色和给这些角色添加权限信息，可修改以下方法
    #initialize_role_permission
  end
end

def eval_cancan_action(controller_name, action)
  case action.to_s
  when "new", "create"
    name = I18n.t(controller_name + ".new.title")
    cancan_action = "create"
  when "edit", "update"
    name = I18n.t(controller_name + ".edit.title")
    cancan_action = "edit"
  when "delete", "destroy"
    name = "删除" 
    cancan_action = "destroy"
  else
    name = I18n.t(controller_name + "." + action.to_s + ".title")
    cancan_action = action.to_s
  end
  action_desc = name 

  return name, cancan_action, action_desc
end


def write_permission(class_name, cancan_action, name, description)
  permission  = Permission.where(["subject_class = ? and action = ?", class_name, cancan_action]).first 
  unless permission
    permission = Permission.new
    permission.subject_class =  class_name
    permission.action = cancan_action
    permission.name = name
    permission.description = description
    permission.save
  else
    permission.name = name 
    permission.description = description
    permission.save
  end
end

def initialize_role_permission
  buyer_permissions = Permission.where(["action = ? and subject_class = ?", "manage", Setting.buyers.class_name])

  buyer_role = Role.where(:name => Setting.roles.buyer).first
  unless buyer_role
    buyer_role = Role.create(:name => Setting.roles.buyer)
  end
  buyer_role.permissions = buyer_permissions

end

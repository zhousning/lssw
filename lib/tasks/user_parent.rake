require 'yaml'
require 'logger'

namespace 'db' do
  desc "update user"
  task(:user_parent => :environment) do
    update_parent
  end
end

def update_parent
  users = YAML.load_file("lib/tasks/parent.yaml")
  
  users.each do |user|
    p_phone = user[0].to_s
    @parent = User.find_by_phone(p_phone)
  
    if @parent && !user[1].nil?
      user[1].each do |c|
        c_phone = c.to_s
        @child = User.find_by_phone(c_phone)
        @child.update(:inviter => @parent.number, :parent => @parent) if @child && !@child.parent
      end
    end
  end
end

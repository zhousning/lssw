require 'yaml'
require 'logger'

namespace 'db' do
  desc "update user"
  task(:user_child => :environment) do
    update_child
  end
end

def update_child
  users = YAML.load_file("lib/tasks/child.yaml")
  
  users.each do |user|
    p_phone = user[0].to_s
    @parent = User.find_by_phone(p_phone)
    without_parents = User.where(:parent => nil, :status => Setting.users.passed).limit(user[1].to_i)
  
    if @parent
      without_parents.each do |c|
        @child = User.find_by_phone(c.phone)
        @child.update(:inviter => @parent.number, :parent => @parent)
      end
    end
  end
end

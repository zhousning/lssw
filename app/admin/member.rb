ActiveAdmin.register Member  do

  permit_params  :name, :email, :homepage, :intro, :level, :photo, :file

  menu label: Setting.members.tag, :priority => 2 
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :name, :label => Setting.members.name
  filter :email, :label => Setting.members.email
  filter :homepage, :label => Setting.members.homepage
  filter :intro, :label => Setting.members.intro
  filter :level, :label => Setting.members.level
  filter :created_at

  index :title=>Setting.members.tag do
    selectable_column
    id_column
    
    column Setting.members.name, :name
    column Setting.members.email, :email
    column Setting.members.homepage, :homepage
    column Setting.members.level, :level

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form :html => {:multipart => true } do |f|
    f.inputs "详情" do
      
      f.input :name, :label => Setting.members.name 
      f.input :email, :label => Setting.members.email 
      f.input :homepage, :label => Setting.members.homepage 
      f.kindeditor :intro, :label => Setting.members.intro 
      f.input :level, :label => Setting.members.level 
      f.file_field :file, :label => Setting.members.photo 
    end
    f.actions
  end

  show :title=>'todo' do
    attributes_table do
      row "ID" do
        member.id
      end
      
      row Setting.members.name do
        member.name
      end
      row Setting.members.email do
        member.email
      end
      row Setting.members.homepage do
        member.homepage
      end
      row Setting.members.intro do
        member.intro.html_safe
      end
      row Setting.members.level do
        member.level
      end
      row Setting.members.photo do
        image_tag("/" + member.photo)
      end

      row "创建时间" do
        member.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        member.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end

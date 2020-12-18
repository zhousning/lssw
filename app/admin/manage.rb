ActiveAdmin.register Manage  do

  permit_params  :title, :content

  menu label: Setting.manages.tag, :priority => 8 
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :title, :label => Setting.manages.title
  filter :content, :label => Setting.manages.content
  filter :created_at

  index :title=>Setting.manages.tag do
    selectable_column
    id_column
    
    column Setting.manages.title, :title

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "详情" do
      
      f.input :title, :label => Setting.manages.title 
      f.kindeditor :content, :label => Setting.manages.content 
    end
    f.actions
  end

  show :title=>Setting.manages.tag  do
    attributes_table do
      row "ID" do
        manage.id
      end
      
      row Setting.manages.title do
        manage.title
      end
      row Setting.manages.content do
        manage.content.html_safe
      end

      row "创建时间" do
        manage.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        manage.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end

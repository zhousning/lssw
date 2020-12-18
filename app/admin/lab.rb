ActiveAdmin.register Lab  do

  permit_params  :title, :content, :order

  menu label: Setting.labs.tag, :priority => 1 
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :title, :label => Setting.labs.title
  filter :content, :label => Setting.labs.content
  filter :order, :label => Setting.labs.order
  filter :created_at

  index :title=>Setting.labs.tag do
    selectable_column
    id_column
    
    column Setting.labs.title, :title
    column Setting.labs.order, :order

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
      
      f.input :title, :label => Setting.labs.title 
      f.kindeditor :content, :label => Setting.labs.content 
      f.input :order, :label => Setting.labs.order 
    end
    f.actions
  end

  show :title=>'todo' do
    attributes_table do
      row "ID" do
        lab.id
      end
      
      row Setting.labs.title do
        lab.title
      end
      row Setting.labs.content do
        lab.content.html_safe
      end
      row Setting.labs.order do
        lab.order
      end

      row "创建时间" do
        lab.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        lab.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end

ActiveAdmin.register Result  do

  permit_params  :title, :content, :order

  menu label: Setting.results.tag, :priority => 3 
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :title, :label => Setting.results.title
  filter :content, :label => Setting.results.content
  filter :order, :label => Setting.results.order
  filter :created_at

  index :title=>Setting.results.tag do
    selectable_column
    id_column
    
    column Setting.results.title, :title
    column Setting.results.order, :order

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
      
      f.input :title, :label => Setting.results.title 
      f.kindeditor :content, :label => Setting.results.content 
      f.input :order, :label => Setting.results.order 
    end
    f.actions
  end

  show :title=>Setting.results.tag do
    attributes_table do
      row "ID" do
        result.id
      end
      
      row Setting.results.title do
        result.title
      end
      row Setting.results.content do
        result.content.html_safe
      end
      row Setting.results.order do
        result.order
      end

      row "创建时间" do
        result.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        result.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end

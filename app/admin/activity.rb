ActiveAdmin.register Activity  do

  permit_params  :title, :content, :category

  menu label: Setting.activities.tag, :priority => 6 
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :title, :label => Setting.activities.title
  filter :created_at

  index :title=>Setting.activities.tag do
    selectable_column
    id_column
    
    column Setting.activities.title, :title

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
      
      f.input :category, :as => :select, :collection => [ Setting.activities.ctg_cmpt, Setting.activities.ctg_org, Setting.activities.ctg_base, Setting.activities.ctg_meb,  ], :label => Setting.activities.category
      f.input :title, :label => Setting.activities.title 
      f.kindeditor :content, :label => Setting.activities.content 
    end
    f.actions
  end

  show :title=>'todo' do
    attributes_table do
      row "ID" do
        activity.id
      end
      
      row Setting.activities.category do
        activity.category
      end
      row Setting.activities.title do
        activity.title
      end
      row Setting.activities.content do
        activity.content.html_safe
      end

      row "创建时间" do
        activity.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        activity.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end

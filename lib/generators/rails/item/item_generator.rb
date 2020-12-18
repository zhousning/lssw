class Rails::ItemGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  #model或attrs 也可通过@model或@columns访问
  argument :model, :type => :string, :default => "model"
  argument :columns, :type => :array, :default => []
  class_option :label, :aliases => '-l', :type => :array, :default => []
  class_option :tag, :aliases => '-t', :type => :array, :default => []
  class_option :image, :aliases => '-i', :type => :boolean, :default => false 

  def generate_model
    attributes = columns.join(" ")
    generate "model", "#{model} #{attributes} --force"
  end

  def generate_setting
    model_name = model.pluralize.underscore
    hash = Hash.new
    columns.each_with_index do |column, index|
      key = column.slice(/([^:]+)/)
      hash[key] = options[:label][index]
    end
    Setting.save(model_name, hash)
  end

  def generate_controller
    @mu = model.underscore
    @mc = model.camelcase
    @mpc = model.pluralize.camelcase
    @mpu = model.pluralize.underscore
    @enclosure = options[:image]

    @attrs = []
    columns.each do |column|
      @attrs << column.slice(/[^:]+/)
    end

    template 'controller.template', "app/controllers/#{controller_name}_controller.rb", @attrs, @mu, @mc, @mpc, @mpu, @enclosure
    template 'index.template', "app/views/#{controller_name}/index.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure
    #template '_form.template', "app/views/#{controller_name}/_form.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure
    #template 'new.template', "app/views/#{controller_name}/new.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure
    #template 'edit.template', "app/views/#{controller_name}/edit.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure
    template 'show.template', "app/views/#{controller_name}/show.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure
    #template 'js.template', "app/assets/javascripts/#{controller_name}.js", @attrs, @mu, @mc, @mpc, @mpu
    template 'scss.template', "app/assets/stylesheets/#{controller_name}.scss"
    template 'model.template', "app/models/#{@mu}.rb", @attrs, @mu, @mc, @mpc, @mpu, @enclosure
    if @enclosure
      template '_enclosure.template', "app/views/#{controller_name}/_enclosure_fields.html.haml"
    end
    template 'admin.template', "app/admin/#{@mu}.rb", @attrs, @mu, @mc, @mpc, @mpu, @enclosure
  end

  private
    def file_name
      model.underscore
    end

    def controller_name
      model.pluralize.underscore
    end

  #model_singularize = model.singularize.underscore
  #class_option :model_singularize, :type => :string, :default => model_singularize
  #class_option :model_pluralize, :type => :string, :default => model_pluralize
  #generate "controller", "#{controller_name}"
end

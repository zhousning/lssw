Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_scope :user do
    get 'forget', to: 'users/passwords#forget'
    patch 'update_password', to: 'users/passwords#update_password'
  end

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'


  resources :labs, :only => [:index, :show]
  resources :members, :only => [:index, :show]
  resources :results, :only => [:index, :show]
  resources :reports, :only => [:index, :show]
  resources :activities, :only => [:index, :show]
  resources :manages, :only => [:index, :show]
  resources :notices, :only => [:index, :show]

  resources :controls, :only => [:index]

  resources :systems, :only => [] do
    get :send_confirm_code, :on => :collection
  end

  resources :users, :only => []  do
    get :center, :on => :collection
    get :alipay_return, :on => :collection
    post :alipay_notify, :on => :collection
    get :mobile_authc_new, :on => :member
    post :mobile_authc_create, :on => :member
    get :mobile_authc_status, :on => :member

  end

  resources :orders, :only => [:new, :create] do
    get :pay, :on => :collection
    get :alipay_return, :on => :collection
    post :alipay_notify, :on => :collection
  end

  resources :tasks, :only => [] do
    get :invite, :on => :collection
  end

  resources :accounts, :only => [:edit, :update] do
    get :recharge, :on => :collection 
    get :info, :on => :collection
    get :status, :on => :collection
  end

  resources :meter_reads do
    post :parse_excel, :on => :collection
    get :meter_xls_download, :on => :collection 
  end

  resources :roles

  root :to => 'home#index'
end

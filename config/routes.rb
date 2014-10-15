Myloud::Application.routes.draw do
  

  get "control_panel" => 'control_panel#index'
  match 'instance_actions/:id', :to => 'control_panel#instance_actions'
  get "download_key" => 'control_panel#download_key'

  resources :accounts
  resources :clouds do
    member do
      put 'start'
      put 'stop'
      put 'reboot'
    end
  end

  resources :admin_tools
  resources :amis
  post '/amis/build' => "amis#build", :as => :build_ami

  devise_for :users

  get "welcome/index"
  root to: "welcome#index"
end


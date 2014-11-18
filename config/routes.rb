Myloud::Application.routes.draw do
  

  get "control_panel" => 'control_panel#index'
  get "control_panel/refresh" => 'control_panel#refresh'
  get "download_key" => 'control_panel#download_key'
  get "generate_key" => 'control_panel#generate_key'

  resources :accounts
  resources :clouds do
    member do
      put 'start'
      put 'stop'
      put 'reboot'
    end  
    collection do
      get 'refresh'
    end
  end

  resources :admin_tools
  resources :amis
  post '/amis/build' => "amis#build", :as => :build_ami

  devise_for :users

  get "welcome/index"
  root to: "welcome#index"
end


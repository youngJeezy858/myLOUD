Myloud::Application.routes.draw do
  
  get "control_panel" => 'control_panel#index'
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

  devise_for :users
  resources :entitlements
  get 'stop/:id', to: 'entitlements#stop'
  get 'start/:id', to: 'entitlements#start'
  get 'reboot/:id', to: 'entitlements#reboot'
  get 'increment_runtime/:id', to: 'entitlements#increment_runtime'
  get 'decrement_runtime/:id', to: 'entitlements#decrement_runtime'
  get 'admin_destroy/:id', to: 'entitlements#admin_destroy'
  get 'admin_stop/:id', to: 'entitlements#admin_stop'
  get 'admin_start/:id', to: 'entitlements#admin_start'
  
  get 'pages/admin' => 'high_voltage/pages#show', id: 'admin'

  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"
  get "my_account/index"
  get "welcome/index"
  root to: "welcome#index"
end


NpsManager::Application.routes.draw do

  resources :practice_groups

  resources :runs do
    resources :fluids
    resources :draws
    resources :emails
    resources :survey_results
    resources :statistics, :only => [:new]
    resources :distributions, :only => [:new]
    resource :practice_groups do
      resource :clinics do
        resources :reports, :except => [:new, :create, :delete]
        resources :statistics, :only => [:show]
      end
    end
    resource :clinics do
      resources :reports, :except => [:new, :create, :delete]
      resources :statistics, :only => [:show]
    end
    resource :practice_groups do
      resources :reports, :except => [:new, :create, :delete]
    end
  end
  resources :survey_results
  resources :practice_reports, :only=>[:index]
  resources :surveys

  resources :clinics

  resources :patients
  resources :dashboards, :only=>[:index]
  resources :reports, :except => [:new, :create, :delete]
  resources :summary
  resources :statistics, :only => [:show, :new]
  
  resources :winners, :only => [:show, :create, :index]
  root :to => "home#index"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

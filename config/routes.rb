BeginningsAndEndings::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'pages#welcome', :via => 'get'
  match 'map' => 'pages#home', :via => 'get'
  match 'map/:code' => 'pages#home', :via => 'get'
  match 'help' => 'pages#help', :via => 'get'
  match 'ie' => 'pages#ie', :via => 'get'

  match 'join' => 'markers#new', :via => 'get'
  match 'join/:code' => 'markers#new', :via => 'get'
  match 'join' => 'markers#create', :via => 'post'
  match 'all' => 'markers#index', :via => 'get'
  match 'ohno' => 'markers#oh_no', :via => 'get'
  match 'thanks/:code' => 'markers#show', :via => 'get'

  match 'markers' => 'markers#index', :via => 'get'
  match 'markers/:code' => 'markers#show', :via => 'get'

  match 'mailer(/:action(/:id(.:format)))' => 'mailer#:action'

  #Static pages
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

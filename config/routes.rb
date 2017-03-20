Hogger::Application.routes.draw do
  resources :blog_comments


  resources :blog_posts


  root :to => 'static#index'
  
  get "static/index"
  get "static/about"

  match 'index' => 'static#index'
  match 'about' => 'static#about'
  match 'faq' => 'static#faq'
  match 'thankyou' => 'static#thankyou'

  #resources :users
  devise_for :users
  resources :users
  
  match 'profile' => 'users#profile'

  resources :logs
  match 'logs/:id/raw' => 'logs#raw', :via => :get
  match 'logs/:id/download' => 'logs#download', :via => :get
  match 'logs/:id' => 'logs#comment', :via => :post

  match '/feed' => 'logs#feed', :as => :feed, :defaults => { :format => 'atom' }


  match 'contact' => 'contact#new', :as => 'contact', :via => :get
  match 'contact' => 'contact#create', :as => 'contact', :via => :post


  #404 - Keep this last
  match '*a' => 'static#notfound'


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

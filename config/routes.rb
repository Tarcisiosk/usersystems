Rails.application.routes.draw do
 # get 'welcome/index'

	get 'users'  => "user#index", as: :users
	get 'users/new'  => 'user#new', as: :new_user 
	get 'users/showImg/:id' => 'user#show_image', as: :photo
	post 'users/generate_api_key' => 'user#generate_api_key'
	post 'users/new'  => 'user#create'
	post 'users/save_settings' => 'user#save_settings'
	post 'users/checked_rows' => 'user#checked_rows'
	post 'users/set_current_emp' => 'user#set_current_emp'

	get 'empresas'=> "empresa#index", as: :empresas
	get 'empresas/new' => "empresa#new", as: :new_empresa
	post 'empresas/new'  => 'empresa#create'
	post 'empresas/save_settings' => 'empresa#save_settings'
	post 'empresas/checked_rows' => 'empresa#checked_rows'

	get 'grupos' => "grupo#index", as: :grupos
	get 'grupos/new' => "grupo#new", as: :new_grupo
	post 'grupos/new'  => 'grupo#create'
	post 'grupos/save_settings' => 'grupo#save_settings'

	get 'subgrupos' => "subgrupo#index", as: :sub_grupos
	get 'subgrupos/new' => "subgrupo#new", as: :new_sub_grupo
	post 'subgrupos/new'  => 'subgrupo#create'
	post 'subgrupos/save_settings' => 'subgrupo#save_settings'

	get 'tipoentidades' => "tipoentidade#index", as: :tipoentidades
	get 'tipoentidades/new' => "tipoentidade#new", as: :new_tipoentidade
	post 'tipoentidades/new'  => 'tipoentidade#create'
	post 'tipoentidades/save_settings' => 'tipoentidade#save_settings'

	get 'nivelacesso' => "nivelacesso#index", as: :nivelacessos
	get 'nivelacesso/new' => "nivelacesso#new", as: :new_nivelacesso
	post 'nivelacesso/new'  => 'nivelacesso#create'
	post 'nivelacesso/save_settings' => 'nivelacesso#save_settings'
	get 'nivelacesso/configurar/:id' => "nivelacesso#configurar"
	post 'nivelacesso/act_acesso/:id' => "nivelacesso#act_acesso"
	post 'nivelacesso/deact_acesso/:id' => "nivelacesso#deact_acesso"

	#put 'nivelacesso/configurar/:id' => 'nivelacesso#configurar', as: :conf_nivelacesso
	
	get "index" => 'index#index', as: :index
	get "error-422" => 'index#notAllowed', as: :notAllowed

	resources :user, only: [:edit, :destroy, :update, :new, :create]
	resources :empresa, only: [:edit, :update, :new, :create]
	resources :grupo, only: [:edit, :destroy, :update, :new, :create]
	resources :subgrupo, only: [:edit, :destroy, :update, :new, :create]
	resources :nivelacesso, only: [:edit, :destroy, :update, :new, :create, :configurar]
	resources :tipoentidade, only: [:edit, :destroy, :update, :new, :create]


	devise_for :users

	devise_scope :user do
		root to: "devise/sessions#new"
	end
	
	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# You can have the root of your site routed with "root"s
	
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

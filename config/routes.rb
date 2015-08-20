Rails.application.routes.draw do
  get 'planoconta/index'

  get 'planoconta/new'

  get 'planoconta/save'

  get 'planoconta/edit'

  get 'planoconta/destroy'

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
	post 'empresas/save'  => 'empresa#save'
	post 'empresas/saveCertificado'  => 'empresa#saveCertificado'
	post 'empresas/save_settings' => 'empresa#save_settings'
	post 'empresas/checked_rows' => 'empresa#checked_rows'

	get 'grupos' => "grupo#index", as: :grupos
	get 'grupos/new' => "grupo#new", as: :new_grupo
	post 'grupos/new'  => 'grupo#create'
	get 'grupos/get_json' => "grupo#send_json"
	get 'grupos/get_empresa' => "grupo#returnEmpresas"
	post 'grupos/save_angular' => 'grupo#save_angular'	
	post 'grupos/save_angular/:id' => 'grupo#save_angular'
	post 'grupos/save_settings' => 'grupo#save_settings'

	get 'subgrupos' => "subgrupo#index", as: :sub_grupos
	get 'subgrupos/new' => "subgrupo#new", as: :new_sub_grupo
	post 'subgrupos/new'  => 'subgrupo#create'
	get 'subgrupos/grupoempresa/:id' => "subgrupo#returnGrupoEmpresas"
	get 'subgrupos/get_json' => "subgrupo#send_json"
	get 'subgrupos/get_itens' => "subgrupo#returnItensUsuario"
	post 'subgrupos/save_angular' => 'subgrupo#save_angular'	
	post 'subgrupos/save_angular/:id' => 'subgrupo#save_angular'
	post 'subgrupos/save_settings' => 'subgrupo#save_settings'

	get 'produtos' => "produto#index", as: :produtos
	get 'produtos/new' => "produto#new", as: :new_produto
	post 'produtos/new'  => 'produto#create'
	get 'produtos/showImg/:id' => 'produto#show_image', as: :p_photo
	post 'produtos/save_settings' => 'produto#save_settings'
	get 'produtos/uniempresa' => "produto#returnEmpresasUnidade"
	get 'produtos/empresagrupo' => "produto#returnEmpresasGrupo"
	get 'produtos/subgrupogrupo' => "produto#returnSubGrupoGrupo"
	get 'produtos/get_json' => "produto#send_json"
	get 'produtos/get_empresa' => "produto#returnEmpresas"
	get 'produtos/get_class' => "produto#returnClassFisc"
	post 'produtos/save_angular' => 'produto#save_angular'	
	post 'produtos/save_angular/:id' => 'produto#save_angular'
	post 'produtos/saveIcms' => 'produto#saveIcms'		

	get 'tipoentidades' => "tipoentidade#index", as: :tipoentidades
	get 'tipoentidades/new' => "tipoentidade#new", as: :new_tipoentidade
	post 'tipoentidades/new'  => 'tipoentidade#create'
	post 'tipoentidades/save_settings' => 'tipoentidade#save_settings'

	get 'entidades'=> "entidade#index", as: :entidades
	get 'entidades/new' => "entidade#new", as: :new_entidade
	post 'entidades/new' => 'entidade#create'
	get 'entidades/get_json' => "entidade#send_json"
	get 'entidades/get_itens' => "entidade#returnItensUsuario"
	get 'entidades/get_empresa' => "entidade#returnEmpresas"
	get 'entidades/get_estado' => "entidade#returnAllEstados"
	post 'entidades/save_settings' => 'entidade#save_settings'
	post 'entidades/save_angular' => 'entidade#save_angular'
	post 'entidades/save_angular/:id' => 'entidade#save_angular'
	get 'entidades/add_end' => "entidade#add_form"

	get 'enderecos'=> "endereco#index", as: :enderecos
	get 'enderecos/new' => "endereco#new", as: :new_endereco
	post 'enderecos/new' => 'endereco#create'
	post 'enderecos/save_settings' => 'endereco#save_settings'

	get 'estados' => "estado#index", as: :estados
	get 'estados/new' => "estado#new", as: :new_estado
	post 'estados/new' => 'estado#create'
	post 'estados/save_settings' => 'estado#save_settings'

	get 'cfops' => "cfop#index", as: :cfops
	get 'cfops/new' => "cfop#new", as: :new_cfop
	get 'cfops/get_json' => "cfop#send_json"
	post 'cfops/save_angular' => 'cfop#save_angular'	
	post 'cfops/save_angular/:id' => 'cfop#save_angular'
	post 'cfops/save_settings' => 'cfop#save_settings'

	get 'unidades' => "unidade#index", as: :unidades
	get 'unidades/new' => "unidade#new", as: :new_unidade
	get 'unidades/get_json' => "unidade#send_json"
	get 'unidades/get_empresa' => "unidade#returnEmpresas"
	post 'unidades/save_angular' => 'unidade#save_angular'	
	post 'unidades/save_angular/:id' => 'unidade#save_angular'
	post 'unidades/save_settings' => 'unidade#save_settings'

	get 'classificacaofiscal' => "classificacaofiscal#index", as: :classificacaofiscals
	get 'classificacaofiscal/new' => "classificacaofiscal#new", as: :new_classificacaofiscal
	post 'classificacaofiscal/save' => 'classificacaofiscal#save'
	post 'classificacaofiscal/saveIcms' => 'classificacaofiscal#saveIcms'		
	post 'classificacaofiscal/save_settings' => 'classificacaofiscal#save_settings'

	get 'icmsinterestadual' => "icmsinterestadual#index", as: :icmsinterestaduals
	post 'icmsinterestadual/saveIcmsinterestadual' => 'icmsinterestadual#saveIcmsinterestadual'		

	get 'nivelacesso' => "nivelacesso#index", as: :nivelacessos
	get 'nivelacesso/new' => "nivelacesso#new", as: :new_nivelacesso
	post 'nivelacesso/new'  => 'nivelacesso#create'
	post 'nivelacesso/save_settings' => 'nivelacesso#save_settings'
	get 'nivelacesso/configurar/:id' => "nivelacesso#configurar"
	post 'nivelacesso/act_acesso/:id' => "nivelacesso#act_acesso"
	post 'nivelacesso/deact_acesso/:id' => "nivelacesso#deact_acesso"

	get 'series' => "serie#index", as: :series
	get 'series/new' => "serie#new", as: :new_serie
	post 'series/save' => 'serie#save'
	post 'series/save_settings' => 'serie#save_settings'

	get 'tipomovimentacaos' => "tipomovimentacao#index", s: :tipomovimentacaos
	get 'tipomovimentacaos/new' => "tipomovimentacao#new", as: :new_tipomovimentacao
	post 'tipomovimentacaos/save' => 'tipomovimentacao#save'
	post 'tipomovimentacaos/save_settings' => 'tipomovimentacao#save_settings'


	get 'movimentoms' => "movimentom#index", as: :movimentoms
	get 'movimentoms/new' => "movimentom#new", as: :new_movimentom
	post 'movimentoms/new'  => 'movimentom#create'
	get 'movimentoms/get_json' => "movimentom#send_json"
	post 'movimentoms/save_angular' => 'movimentom#save_angular'	
	post 'movimentoms/save_angular/:id' => 'movimentom#save_angular'
	post 'movimentoms/save_settings' => 'movimentom#save_settings'
	get 'movimentoms/get_entidades' => "movimentom#returnEntidadeMovimentos"
	get 'movimentoms/get_produtos' => "movimentom#returnProdutosMovimentos"
	get 'movimentoms/get_icms/:id' => "movimentom#returnIcms"

	get 'planocontas' => "planoconta#index", as: :planocontas
	get 'planocontas/new' => "planoconta#new", as: :new_planoconta
	post 'planocontas/save' => 'planoconta#save'		
	post 'planoconta/save_settings' => 'planoconta#save_settings'

	#put 'nivelacesso/configurar/:id' => 'nivelacesso#configurar', as: :conf_nivelacesso
	
	get "index" => 'index#index', as: :index
	
	get "error-422" => 'index#notAllowed', as: :notAllowed

	resources :user, only: [:edit, :destroy, :update, :new, :create]
	resources :empresa, only: [:edit, :update, :new, :create]
	resources :grupo, only: [:edit, :destroy, :update, :new, :create]
	resources :subgrupo, only: [:edit, :destroy, :update, :new, :create]
	resources :estado, only: [:edit, :destroy, :update, :new, :create] 
	resources :classificacaofiscal, only: [:edit, :destroy, :update, :new, :create] 
	resources :icmsinterestadual, only: [:edit, :destroy, :update, :new, :create] 
	resources :nivelacesso, only: [:edit, :destroy, :update, :new, :create, :configurar]
	resources :tipoentidade, only: [:edit, :destroy, :update, :new, :create]
	resources :produto, only: [:edit, :destroy, :update, :new, :create]
	resources :entidade, only: [:edit, :update, :new, :create, :destroy]
	resources :endereco, only: [:edit, :update, :new, :create, :destroy]
	resources :cfop, only: [:edit, :destroy, :new] 
	resources :unidade, only: [:edit, :destroy, :new] 
	resources :serie, only: [:edit, :update, :new, :create, :destroy]
	resources :tipomovimentacao, only: [:edit, :update, :new, :create, :destroy]
	resources :movimentom, only: [:edit, :update, :new, :create, :destroy]
	resources :planoconta, only: [:edit, :update, :new, :create, :destroy]



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

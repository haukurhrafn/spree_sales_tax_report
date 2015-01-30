Spree::Core::Engine.routes.prepend do  
  namespace :admin do
    resources :reports, :only => [:index, :show] do  # <= add this block
      collection do
        get :sales_tax
        post :sales_tax
      end
    end
  end
end

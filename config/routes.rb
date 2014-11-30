Rails.application.routes.draw do

  namespace :openscap, :module => :foreman_scap do
    resources :scap_contents
    resources :arf_reports, :only => [:index, :show, :destroy]
    resources :policies do
      collection do
        post 'scap_content_selected'
      end
    end
    match 'dashboard', :to => 'scaptimony_dashboard#index', :as => "scaptimony_dashboard"
  end
  namespace :api do
    namespace :v2 do
      namespace :openscap do
        post 'arf_reports/:cname/:policy/:date', \
              :constraints => { :cname => /[^\/]+/ }, :to => 'arf_reports#create'
      end
    end
  end
end

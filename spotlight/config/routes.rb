Rails.application.routes.draw do
  mount Blacklight::Oembed::Engine, at: 'oembed'
  root to: 'spotlight/exhibits#index'
  # root to: "catalog#index" # replaced by spotlight root path
  devise_for :users
  mount Riiif::Engine => '/images', as: 'riiif'
  mount Spotlight::Engine, at: 'spotlight'
  mount Blacklight::Engine => '/'

  get '/downloads/:id', to: redirect { |params, request| "#{ENV['HYRAX_HOST_URL']}/downloads/#{request.params[:id]}?#{request.params.except(:id).to_query}" }

  concern :searchable, Blacklight::Routes::Searchable.new
  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

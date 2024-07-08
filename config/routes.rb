Rails.application.routes.draw do
  get 'trader/dashboard'
  get 'sell_stock', to: 'trader#sell_stock'
  post 'sell_transaction', to: 'trader#sell_transaction'
  get 'stocks/index'
  get 'stocks/show'
  # Admin namespace for admin-related resources
  namespace :admin do
    resources :users, only: [:index] do
      collection do
        get :approved_accounts
        get :rejected_accounts
        get :pending_accounts
        get :deleted_accounts
      end
      member do
        patch :approve
        patch :reject
        patch :add_to_pending
        patch :delete_account
        patch :change_role_to_admin
        patch :change_role_to_trader
      end
    end
  end

  resources :stocks, only: [:index, :show] do
    collection do
      get 'fetch_data'
    end
    member do
      get 'buy_stock'
      post 'buy_transaction'
    end
  end

  # Devise routes for user authentication
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Root route
  root to: 'home#index'

  # Example route for Rails health check
  get "up" => "rails/health#show", as: :rails_health_check
end

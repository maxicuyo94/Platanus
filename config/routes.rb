# frozen_string_literal: true

# config/routes.rb
Rails.application.routes.draw do
  root to: 'buda#index'

  get '/search' => 'buda#search'
end

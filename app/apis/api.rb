require 'app/helpers/pagination_helper'
require 'app/apis/base_api'
require 'app/apis/breweries_api'
require 'app/apis/webhooks_api'

module Goodbrews
  class API < BaseAPI
    mount BreweriesAPI => :breweries
    mount WebhooksAPI  => '/brewery_db/webhooks/'

    any '*catchall' do
      error! :not_found
    end
  end
end

# frozen_string_literal: true

require 'roda'
require_relative 'lib/ein'

class App < Roda
  DATA_FILE = 'data.pstore'

  plugin :json

  opts[:ein] = EIN.instance

  route do |r|
    # GET /000003154 request
    r.is ':ein' do |ein|
      opts[:ein].find(ein) or response.status = 404
    end
  end
end

run App.freeze.app

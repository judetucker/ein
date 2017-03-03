class App < Roda
  DATA_FILE = 'data.pstore'

  plugin :json
  plugin :render, engine: 'haml'
  plugin :param_matchers

  opts[:ein] = EIN.instance

  route do |r|
    r.root do
      render("index")
    end

    # GET /000003154 request
    r.on param: 'ein' do |ein|
      puts ein
      opts[:ein].find(ein.to_s) or response.status = 404
    end
  end
end

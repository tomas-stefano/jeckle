Jeckle::Setup.register(:my_super_api) do |api|
  api.base_uri   = 'http://my-super-api.com.br'
  api.headers    = { 'Content-Type' => 'application/json' }
  api.logger     = Logger.new(STDOUT)
  api.basic_auth = { username: 'steven_seagal', password: 'youAlwaysLose' }
  api.namespaces = { prefix: 'api', version: 'v1' }
  api.params     = { hello: 'world' }
end

require 'sinatra'

set :port, 45000

get '/' do
  erb :landing_page
end

get '/library' do
  erb :library
end

get '/signup' do
  erb :signup
end

# API

get '/api/user/signup' do
  User.signup(params)
end

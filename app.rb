require 'sinatra'
require 'sinatra/cookies'
require 'tilt/erb'

require_relative('lib/user')

set :port, 45000


# ROUTING

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
post '/api/user/signup' do
  if res = User.signup(params)
    cookies[:u_name] = res.name
    cookies[:u_token] = res.token
    erb :signup_success
  else
    @msg = res
    erb :signup_error
  end
end

post '/api/user/signin' do
  if user = User.login(params)
    cookies[:u_name] = user.name
    cookies[:u_token] = user.token
    puts 'Logged in successfully'
  else
    puts 'error logging in'
  end

  redirect '/'
end

get '/api/user/signout' do
  cookies.clear
  redirect '/'
end

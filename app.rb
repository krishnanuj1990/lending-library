require 'sinatra'
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
  res = User.signup(params)

  if res
    erb :signup_success
  else
    @msg = res
    erb :signup_error
  end

end

post '/api/user/signin' do
  if user = User.login(params)
    puts 'Logged in successfully'
  else
    puts 'error logging in'
  end

  redirect '/'
end

require 'sinatra'

require_relative('lib/user')

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
post '/api/user/signup' do
  res = User.signup(params)
  puts res

  if res == true
    erb :signup_success
  else
    @msg = res
    erb :signup_error
  end

end

post '/api/user/signin' do
  if user = User.authenticate(params)
    session[:user] = user
    puts 'Logged in successfully'
  else
    puts 'error logging in'
  end

  redirect '/'
end

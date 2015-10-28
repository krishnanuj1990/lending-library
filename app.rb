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

get '/signup/success' do

end

get '/signup/error' do
  @res = params['response']
  puts @res
  erb :signup_error
end



# API
post '/api/user/signup' do
  res = User.signup(params)
  puts res

  if res == true
    # redirect '/signup/success'
    erb :signup_success
  else
    # msg = { :response => res }
    # redirect "/signup/error?#{msg}"
    @msg = res
    erb :signup_error
  end

end

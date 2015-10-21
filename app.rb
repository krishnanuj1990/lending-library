require 'sinatra'

set :port, 45000

get '/' do
  erb :landing_page
end

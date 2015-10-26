require 'sinatra'
require 'sequel'
require 'json'
require 'open-uri'

set :port, 45000

Sequel::Model.plugin :json_serializer

# DATABASE
DB = Sequel.connect('sqlite://library.db')

# If you want to delete the tables and remake them change the ? to a !
# The ? makes tables if they don't exist
DB.create_table? :books do 
  primary_key :book_id
  String :title, :text=>true
  String :subtitle, :text=>true
  String :author
  String :isbn
  String :edition
  Integer :user_id
  String :location
end

DB.create_table? :checkouts do 
  primary_key :checkout_id
  foreign_key :book_id, :books  
  Integer :user_id
  Date :checkout_date
  Date :due_date
  Date :return_date
  Integer :return_condition
end

DB.create_table? :users do 
  primary_key :user_id
  String :email
  String :password
  String :password_reset_hash
  Integer :permissions
  String :first_name
  String :last_name
  String :location
end

# Uncomment these lines if you want some stuff inserted into the Database to play with
# Users.create(:email => 'Alex', :first_name => 'Alex', :last_name => 'Name', :location => '1')
# Users.create(:email => 'Drew', :first_name => 'Drew', :last_name => 'Name', :location => '2')
# Users.create(:email => 'Chris', :first_name => 'Chris', :last_name => 'Name', :location => '3')

# Books.create(:title => 'Test 1', :subtitle => 'Book 1', :author => 'Alex', :isbn => '123456789', :edition => '1', :user_id => 1, :location => '4')
# Books.create(:title => 'Test 2', :subtitle => 'Book 2', :author => 'Randy', :isbn => '234567891', :edition => '1', :user_id => 2, :location => '2')
# Books.create(:title => 'Test 3', :subtitle => 'Book 3', :author => 'Chris', :isbn => '345678912', :edition => '1', :user_id => 3, :location => '5')

class Books < Sequel::Model
end

class Checkouts < Sequel::Model
end

class Users < Sequel::Model
end


get '/' do
  erb :landing_page
end

get '/library' do
  erb :library
end

get '/api/isbninfo' do
  isbn = params[:isbn]
  content = open("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}").read
  content
end
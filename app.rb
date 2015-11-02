require 'sinatra'
require 'sequel'
require 'json'
require 'open-uri'
require 'uri'
require 'date'
require 'sinatra/cookies'
require 'tilt/erb'

require_relative('lib/user')

set :port, 23455
set :environment, :production


# ROUTING

Sequel::Model.plugin :json_serializer

# DATABASE
DB = Sequel.connect('sqlite://library.db')

# If you want to delete the tables and remake them change the ? to a !
# ::The ? makes tables if they don't exist::
DB.create_table! :books do 
  primary_key :book_id
  String :title, :text=>true
  String :subtitle, :text=>true
  String :author
  String :isbn
  String :edition
  String :publication_year
  Integer :user_id
  String :location
end

DB.create_table! :checkouts do 
  primary_key :checkout_id
  Integer :book_id
  Integer :user_id
  Date :checkout_date
  Date :due_date
  Date :return_date
  Integer :return_condition
end

DB.create_table! :users do 
  primary_key :user_id
  String :email
  String :password
  String :password_reset_hash
  Integer :permissions
  String :first_name
  String :last_name
  String :location
end

class Books < Sequel::Model
end

class Checkouts < Sequel::Model
end

class Users < Sequel::Model
end

# Uncomment these lines if you want some stuff inserted into the Database to play with
Users.create(:email => 'Alex', :first_name => 'Alex', :last_name => 'Name', :location => '1')
Users.create(:email => 'Drew', :first_name => 'Drew', :last_name => 'Name', :location => '2')
Users.create(:email => 'Chris', :first_name => 'Chris', :last_name => 'Name', :location => '3')

Books.create(:title => 'Test 1', :subtitle => 'Book 1', :author => 'Alex', :isbn => '123456789', :edition => '1', :publication_year => '2003', :user_id => 1, :location => '4')
Books.create(:title => 'Test 2', :subtitle => 'Book 2', :author => 'Randy', :isbn => '234567891', :edition => '1', :publication_year => '2003', :user_id => 2, :location => '2')
Books.create(:title => 'Test 3', :subtitle => 'Book 2', :author => 'Chris', :isbn => '345678912', :edition => '1', :publication_year => '2003', :user_id => 3, :location => '5')
Books.create(:title => 'Test 4', :subtitle => 'Book 2', :author => 'Chris', :isbn => '345678212', :edition => '1', :publication_year => '2005', :user_id => 3, :location => '5')
Books.create(:title => 'Test 22', :subtitle => 'Book 5', :author => 'Chris', :isbn => '345118912', :edition => '1', :publication_year => '2002', :user_id => 3, :location => '5')

Checkouts.create(:book_id => '1', :user_id => '1', :checkout_date => '2015-10-28', :due_date => '2015-11-23')
Checkouts.create(:book_id => '2', :user_id => '3', :checkout_date => '2015-10-27', :due_date => '2015-11-26')
Checkouts.create(:book_id => '3', :user_id => '2', :checkout_date => '2015-10-23', :due_date => '2015-11-22')
Checkouts.create(:book_id => '1', :user_id => '2', :checkout_date => '2015-10-23', :due_date => '2015-11-23')
Checkouts.create(:book_id => '2', :user_id => '2', :checkout_date => '2015-10-23', :due_date => '2015-11-21')


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
get '/api/google-api/isbn-info' do
  isbn = params[:isbn]
  content = open("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}").read
  content
end

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

<<<<<<< HEAD









# Start Database API
get '/api/db/add-book' do
  title = params[:title]
  subtitle = params[:subtitle]
  author = params[:author]
  isbn = params[:isbn]
  edition = params[:edition]
  publication_year = params[:publication_year]
  user_id = params[:user_id]
  location = params[:location]
  
  query = "INSERT INTO books (title, subtitle, author, isbn, edition, publication_year, user_id, location)"
  query += "VALUES ('#{title}', '#{subtitle}', '#{author}', '#{isbn}', '#{edition}', '#{publication_year}', #{user_id}, '#{location}')"
  dataset = DB[query].all 
end

get '/api/db/remove-book' do
  book_id = params[:book_id]
  dataset = DB["DELETE FROM books where book_id = #{book_id}"].all  
end

# Get Info for a Single Book
get '/api/db/get-book' do
  book_id = params[:book_id]
  dataset= DB["SELECT b.*, u.first_name, u.last_name FROM books b join users u on u.user_id = b.user_id WHERE b.book_id = #{book_id}"].all  
  dataset.to_json
end

# Get all books in DB
get '/api/db/get-books' do
  dataset= DB['SELECT b.*, u.first_name, u.last_name FROM books b join users u on u.user_id = b.user_id'].all  
  dataset.to_json
end

# Get all books a certain user owns
get '/api/db/get-user-books' do
  user_id = params[:user_id]
  dataset= DB["SELECT b.*, u.first_name, u.last_name FROM books b join users u on u.user_id = b.user_id WHERE b.user_id = #{user_id}"].all  
  dataset.to_json
end

# Search All books by a field and search text
get '/api/db/search-books' do
  search_field = params[:search_field]
  search_by = params[:search_by]
  dataset= DB["SELECT b.*, u.first_name, u.last_name FROM books b join users u on u.user_id = b.user_id where b.#{search_field} like '%#{search_by}%'"].all  
  dataset.to_json
end

# Search All books by titles
get '/api/db/search-books-by-title' do
  search_by = params[:search_by]
  dataset = DB["SELECT b.*, u.first_name, u.last_name FROM books b join users u on u.user_id = b.user_id where b.title like '%#{search_by}%' or b.subtitle like '%#{search_by}%'"].all  
  dataset.to_json
end

## Checkout Related
get '/api/db/get-checkout' do
  checkout_id = params[:checkout_id]
  dataset= DB["SELECT c.*, u.first_name, u.last_name FROM checkouts c join users u on u.user_id = c.user_id WHERE c.checkout_id = #{checkout_id}"].all  
  dataset.to_json
end

get '/api/db/get-user-checkouts' do
  user_id = params[:user_id]
  dataset= DB["SELECT c.*, u.first_name, u.last_name FROM checkouts c join users u on u.user_id = c.user_id WHERE c.user_id = #{user_id}"].all  
  dataset.to_json
end

get '/api/db/get-checkouts' do
  dataset= DB['SELECT c.*, u.first_name, u.last_name FROM checkouts c join users u on u.user_id = c.user_id'].all  
  dataset.to_json
end

get '/api/db/checkout-book' do
  book_id = params[:book_id]
  user_id = params[:user_id]
  checkout_date = params[:checkout_date]
  due_date = params[:due_date]
  dataset = DB["INSERT INTO checkouts (book_id, user_id, checkout_date, due_date) VALUES (#{book_id}, #{user_id}, '#{checkout_date}', '#{due_date}')"].all
end

get '/api/db/return-book' do
  checkout_id = params[:checkout_id]
  return_date = params[:return_date]
  return_condition = params[:return_condition]
  dataset = DB["UPDATE checkouts SET return_date = '#{return_date}', return_condition = #{return_condition} WHERE checkout_id = #{checkout_id}"].all
end
# End Database API








# Start Database Middleware
def dbAddBook(title, subtitle, author, isbn, edition, publication_year, user_id, location)

  uri = URI.parse("http://localhost:#{settings.port}/api/db/add-book")
  uri.query = URI.encode_www_form(
    'title' => title,
    'subtitle' => subtitle,
    'author' => author,
    'isbn' => isbn,
    'edition' => edition,
    'publication_year' => publication_year,
    'user_id' => user_id,
    'location' => location
  )
  content = open(uri.to_s).read
  return content
end

def dbRemoveBook(bookId)
  content = open("http://localhost:#{settings.port}/api/db/remove-book?book_id=#{bookId}").read
  return content
end

def dbGetBook(bookId)
  content = open("http://localhost:#{settings.port}/api/db/get-book?book_id=#{bookId}").read
  return content
end

def dbGetBooks()
  content = open("http://localhost:#{settings.port}/api/db/get-books").read
  return content
end

def dbGetUserBooks(userId)
  content = open("http://localhost:#{settings.port}/api/db/get-user-books?user_id=#{userId}").read
  return content
end

def dbSearchBooks(searchField, searchBy)

  return nil unless ['title', 'author', 'isbn', 'edition', 'publication_year', 'location'].include? searchField

  if searchField == 'title'
    content = open("http://localhost:#{settings.port}/api/db/search-books-by-title?search_by=#{searchBy}").read
  else
    content = open("http://localhost:#{settings.port}/api/db/search-books?search_field=#{searchField}&search_by=#{searchBy}").read
  end 

  return content
end

## Checkout Related
def dbGetCheckout(checkoutId)
  content = open("http://localhost:#{settings.port}/api/db/get-checkout?checkout_id=#{checkoutId}").read
  return content
end

def dbGetUserCheckouts(userId)
  content = open("http://localhost:#{settings.port}/api/db/get-user-checkouts?user_id=#{userId}").read
  return content
end

def dbGetCheckouts()
  content = open("http://localhost:#{settings.port}/api/db/get-checkouts").read
  return content
end

def dbCheckoutBook(bookId, userId)
  current_time = DateTime.now
  # Add two weeks to the current date
  due_time = Time.now + (2*7*24*60*60)
  

  # Get the dates from the vareables
  checkoutDate = current_time.strftime "%Y-%m-%d"
  dueDate = due_time.strftime "%Y-%m-%d"

  uri = URI.parse("http://localhost:#{settings.port}/api/db/checkout-book")
  uri.query = URI.encode_www_form(
    'book_id' => bookId,
    'user_id' => userId,
    'checkout_date' => checkoutDate,
    'due_date' => dueDate
  )
  content = open(uri.to_s).read
  return content
end

def dbReturnBook(checkoutId, returnCondition)  
  current_time = DateTime.now

  returnDate = current_time.strftime "%Y-%m-%d"

  uri = URI.parse("http://localhost:#{settings.port}/api/db/return-book")
  uri.query = URI.encode_www_form(
    'checkout_id' => checkoutId,
    'return_date' => returnDate,
    'return_condition' => returnCondition
  )

  content = open(uri.to_s).read
  return content
end
# End Database Middleware
=======
get '/api/user/signout' do
  cookies.clear
  redirect '/'
end
>>>>>>> upstream/master

require 'open-uri'
require 'uri'
require 'date'

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
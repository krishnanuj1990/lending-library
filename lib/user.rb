<<<<<<< HEAD
require 'data_mapper'
=======
>>>>>>> 62ca994a3aa2a4e33ca3e515abd2e6acc6840554
require 'active_support/all'
require 'securerandom'
require 'bcrypt'

<<<<<<< HEAD

# DATABASE
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/lib/users.db")

class Users
  include DataMapper::Resource
  property :user_id, Serial
  property :username, Slug, :required => true, :default => ''
  property :email, Slug, :required => true, :default => ''
  property :password, Text, :required => true, :default => ''
  property :token, Text, :required => true, :default => ''
end

DataMapper.finalize.auto_upgrade!

=======
>>>>>>> 62ca994a3aa2a4e33ca3e515abd2e6acc6840554
class User
  include BCrypt
  attr_reader :name
  attr_reader :token

  def initialize(params = {})
    @name = params[:name]
    @token = params[:token]
  end

  def self.login(params = {})
    return nil if params[:username].blank? || params[:password].blank?

    f_username = params[:username].downcase
    f_password = params[:password]
    db_usr = ''
    db_pwd = ''
    db_token = ''

<<<<<<< HEAD
    @user_list = Users.all(:username => f_username)
=======
    @user_list = Users.where(:username => f_username).all
>>>>>>> 62ca994a3aa2a4e33ca3e515abd2e6acc6840554


    if @user_list.count > 0
      @user_list.each do |user|
        db_usr = user.username
        db_pwd = user.password
        db_token = user.token

        return nil if f_username != db_usr
      end

      # Hash user inputted password
      password = BCrypt::Password.new(db_pwd)

      # The f_password gets hashed by the != method and then compared
      if password != f_password
        puts 'Login Failed : incorrect password'
        return nil
      else
        return User.new(:name => db_usr, :token => db_token)
      end

    else
      puts 'Login Failed : no user found'
      return nil
    end

  end

  def self.signup(params = {})
    return nil if params[:username].blank? || params[:password].blank? || params[:email].blank?

    f_username = params[:username].downcase
<<<<<<< HEAD
    @users = Users.all(:username => f_username)

    if @users.count == 0
      u = Users.new
      u.username = f_username
      u.email = params[:email].downcase
      u.password = Password.create(params[:password])
      u.token = SecureRandom.base64(16)
      u.save
      return User.new(:name => u.username, :token => u.token)
=======
    @users = Users.where(:username => f_username).all

    if @users.count == 0
      token = SecureRandom.base64(16)

      Users.create(
        :username => f_username, 
        :email => params[:email].downcase, 
        :password => Password.create(params[:password]), 
        :token => token
      )

      return User.new(:name => f_username, :token => token)
>>>>>>> 62ca994a3aa2a4e33ca3e515abd2e6acc6840554
    else
      return 'Username is already in use.'
    end
  end

  def self.authenticate(params = {})

  end

end

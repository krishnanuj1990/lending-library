require 'data_mapper'
require 'active_support/all'
require 'securerandom'
require 'bcrypt'


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

    @user_list = Users.all(:username => f_username)


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
    @users = Users.all(:username => f_username)

    if @users.count == 0
      u = Users.new
      u.username = f_username
      u.email = params[:email].downcase
      u.password = Password.create(params[:password])
      u.token = SecureRandom.base64(16)
      u.save
      return User.new(:name => u.username, :token => u.token)
    else
      return 'Username is already in use.'
    end
  end

end

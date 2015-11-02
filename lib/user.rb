require 'data_mapper'
require 'bcrypt'


# DATABASE
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/users.db")

class UsersDB
  include DataMapper::Resource
  property :user_id, Serial
  property :username, Text, :required => true
  property :password, Text, :required => true
end

DataMapper.finalize.auto_upgrade!

class User
  include BCrypt
  attr_reader :name

  def self.authenticate(params = {})
    return nil if params[:username].blank? || params[:password].blank?
    
    @user_list = UsersDB.all(:username => params[:username].downcase)

    f_username = params[:username].downcase
    f_password = params[:password]
    db_usr = ''
    db_pwd = ''

    if @user_list.count > 0
      @user_list.each do |user|
        puts user.username
        puts user.password

        return nil if f_username != user.username

        db_pwd = user.password
        db_usr = user.username
      end

      password = Password.new(db_pwd)

      # The password param gets hashed by the == method.
      if password != f_password
        puts 'Login Failed'
        return nil
      else
        puts 'Login Succeeded'
        User.new(db_usr)
      end

    else
      puts 'Login Failed'
      return nil
    end

  end

  def self.signup(params = {})
    @users = UsersDB.all(:username => params[:username])

    u = UsersDB.new
    u.username = params[:username]

    if not @users.count > 0
      u.password = Password.create(params[:password])
      u.save
      return true
    else
      return 'Username is already in use.'
    end
  end

  def initialize(username)
    @name = username.capitalize
  end
end

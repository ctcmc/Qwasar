require 'sinatra'
require 'sqlite3'
require 'erb'
set :port, 3000
enable :sessions


db = SQLite3::Database.new "db.sql"

users = db.execute <<-SQL
    create table if not exists users (
        firstname varchar(15),
        lastname varchar(15),
        age int,
        password varchar(30),
        email varchar(30),
        id int
    );
SQL

class User
    @@db = SQLite3::Database.open "db.sql"

    def initialize( firstname, lastname, age, password, email)
        @firstname = firstname
        @lastname = lastname
        @age = age
        @password = password
        @email = email
    end

    def create()
       @id = @@db.last_insert_row_id
       @@db.execute("INSERT INTO users (firstname, lastname, age, password, email, id)
                    VALUES (?,?,?,?,?,?)", [@firstname, @lastname, @age, @password, @email, @id])
        return @id
    end

    def find(param:, val:)
        results = @@db.query("SELECT * FROM users WHERE #{param}=?", val)
        return results
    end

    def find_sanitized(param:, val:)
        results = @@db.query("SELECT firstname, lastname, age, email, id FROM users WHERE #{param}=?", val)
        return results
    end

    def user_auth(email:, password:)
        results = @@db.query("SELECT 1 FROM users WHERE email=? AND password=?", email, password)
        return results
    end

    def find_id(param:, val:)
        results = @@db.query("SELECT id FROM users WHERE #{param}=?", val)
        return results
    end

    def all()
        results = @@db.query("SELECT * FROM users")
        return results
    end

    def update( id:, attribute:, value:)
        @@db.execute("UPDATE users SET #{attribute} = ? WHERE id=?", value, id)
        find_sanitized(db, id:id)
    end

    def destroy(id:)
        @@db.execute("DELETE FROM users WHERE id=?", id)
    end

    
end

get '/' do
    @user = User.new("Admin", "Cable", 26,  "1234", "223d@gmail.com")
    @results = @user.all
    erb :index, {:locals => params}
end

get '/users' do
    @user = User.new("Admin", "Cable", 26,  "1234", "223d@gmail.com")
    results = @user.all
    results.each{ |row| 
    row.delete_at(3)
    puts row.join(',')}
end

post '/users' do
    @firstname = params["firstname"]
    @lastname = params["lastname"]
    @age = params["age"]
    @password = params["password"]
    @email = params["email"]

    @user = User.new(@firstname, @lastname, @age, @password, @email)
    @id = @user.create
    results = user.find_sanitized(param: "id", val: @id)
    results.each{ |row| puts row.join(',')}
end

put '/users' do
    if session[:logged_in]
        puts "password changed"
        puts user.update(id:session[:user_id], attribute:"password", value: params["password"] )
    end
end


post '/sign_in' do
    # input is a hash named params
    # {email: "1234@gmail.com", password:"1234"

    if user.user_auth(email: params["email"], password: params["password"])
        puts "User Authenticated"
        @id = user.find_id(param: "email", val: params["email"])
        session[:user_id] = @id
        session[:logged_in] = true # returning to a session 
        redirect "/"
    else
        puts "User login not found"
        redirect "/sign_in"
    end
end

delete 'sign_out' do
    if session[:logged_in]
        session.clear
        halt 204
    else
        puts "No user to log out!"
        redirect "/"
    end
end

delete "/users" do
    if session[:logged_in]
        user.destroy(id: session[:user_id])
        session.clear
        halt 204
    else
        puts "No user to delete!"
        redirect "/"
    end
end
require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require './models'

set :database, "sqlite3:groupies.sqlite3"
set :sessions, :true
use Rack::Flash, sweep: true

def current_user
	if session[:user_id]
		User.find(session[:user_id])
	else
		nil
	end
end

get	'/' do 
	
end

get '/profile' do
	@post = Post.all
	erb :profile
end

get '/login' do
	erb :login
end

get '/logout' do
	session[:user_id] = nil
	flash[:notice] = "Logged out!"
	redirect to '/login'
end

get '/signup' do
	erb :signup
end

post '/signup' do 
	user = User.create(params[:user]) 
	session[:user_id] = user.id
	p user
	redirect to '/profile'
end

post '/login' do
	user = User.find_by(username: params[:username])
	if user and user.password == params['password']
		session[:user_id] = user.id
		flash[:notice] = "Logged in!"
		redirect to '/profile'
	else
		flash[:notice] = "There was a problem logging in!"
		redirect to '/login'
	end
end

post '/newpost' do
	post = Post.create(params[:post])
	redirect to '/profile'
end


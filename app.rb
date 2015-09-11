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
	@posts = Post.last(10).reverse
	erb :newsfeed
end

get '/fellowgroupie/:id' do
	begin
		@user = User.find(params[:id])
		erb :fellowgroupie
	rescue
		flash[:notice] = "That user does not exist."
		redirect to '/'
	end
end

get '/othergroupies' do
	@users = User.all
	erb :othergroupies
end

get'/othergroupies/:id' do
	begin
		@user = User.find(params[:id])
		erb :othergroupies
	rescue
		flash[:notice] = "That user does not exist."
		redirect to '/'
	end
end

get '/profile' do
	@posts = current_user.posts
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

get '/account' do
	erb :account
end

get '/editaccount' do
	@user = current_user
	erb :editaccount
end

post '/editaccount' do
	@user = current_user
	current_user.update(params[:user])
	flash[:notice] = "Profile was successfully updated."
	redirect to '/account'
end

get '/follow/:id' do
	@relationship = Relationship.create(follower_id: current_user.id, 
																			followed_id: params[:id])
	flash[:notice] = "Followed!"
	redirect to '/profile'
end

get '/unfollow/:id' do
	@relationship = Relationship.find_by(follower_id: current_user.id,
											 followed_id: params[:id])
	@relationship.destroy
	flash[:notice] = "Unfollowed!"
	redirect to '/profile'
end

post '/delete' do
	current_user.destroy
	redirect to '/finethen'
end

get '/finethen' do
	erb :finethen
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
	user = current_user
	post = Post.new(params[:post])
	post.user_id = current_user.id
	post.save

	p post
	redirect to '/profile'
end


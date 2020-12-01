require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'

set :database, {adapter: "sqlite3", database: "leprosorium.db"}

class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end


get '/' do
  @posts = Post.order 'created_at DESC'
  erb :index

end


get '/new' do
  erb :new
end

post '/new' do
  username = params[:username]
  content = params[:content]

  hh = { :username => 'Enter username',
          :content => 'Enter post' }

  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :new
  end
  
  @c = Post.new params[:post]
  @c.save

  redirect to '/'
end

get '/post/:post_id' do
  post_id = params[:post_id]

  @post = Post.find(params[:post_id])
  @comments = Comment.where(post_id: params[:post_id])
  
  erb :post
end


post '/post/:post_id' do
  post_id = params[:post_id]
  #redirect to '/post/' + post_id

  @c = Comment.new params[:comment]
  @c.save
  if @c.save 
    erb "ok, everythings good"
  else
    @error = @c.errors.full_messages.first
    erb :index
  end

  redirect to '/post/' + post_id
end

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sqlite3'

set :database, {adapter: "sqlite3", database: "leprosorium.db"}

class Post < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
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

  #@db.execute 'insert into posts 
  #(content, created_date, username) values 
  #(?, datetime(), ?)', [content, username]

  redirect to '/'
end

get '/post/:post_id' do
  post_id = params[:post_id]
  results = @db.execute 'select * from posts where id = ?', [post_id]
  @row = results[0]

  @comments = @db.execute 'select * from comments
   where post_id = ? order by id desc', [post_id]

  erb :post
end


post '/post/:post_id' do
  post_id = params[:post_id]
  content = params[:content]

  if content.length <= 0
    @error = 'Type comment text'
    #return erb :post
    redirect to '/post/' + post_id
  end

  @db.execute 'insert into comments 
  (content, created_date, post_id) values 
  (?, datetime(), ?)', [content, post_id]

  redirect to '/post/' + post_id
end

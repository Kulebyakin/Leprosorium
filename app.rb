require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'Leprosorium.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS posts 
  (
    id  INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content TEXT,
    username TEXT
  )'

  @db.execute 'CREATE TABLE IF NOT EXISTS comments 
  (
    id  INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content TEXT,
    post_id INTEGER
  )'
end

get '/' do
  @results = @db.execute 'select * from posts order by id desc'
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
  
  @db.execute 'insert into posts 
  (content, created_date, username) values 
  (?, datetime(), ?)', [content, username]

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

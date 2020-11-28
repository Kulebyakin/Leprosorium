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
    content TEXT
  )'
end

get '/' do
  erb 'Can you handle a '
end


get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  if content.length <= 0
    @error = 'type post text'
    return erb :new
  end

  @db.execute 'insert into posts (content, created_date) values (?, datetime())', [content]

  erb "You typed #{content}"
end
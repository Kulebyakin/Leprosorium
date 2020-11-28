require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


get '/' do
  erb 'Can you handle a '
end


get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  erb "You typed #{content}"
end
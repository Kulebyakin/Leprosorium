require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


get '/' do
  erb 'Can you handle a '
end


get '/new' do
  erb "Hello World"
end
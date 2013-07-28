require 'sinatra'

cache_control :public, :max_age => 3600

get '/', :provides => 'html' do
  haml :index
end

get '/stylesheets/*.css', :provides => 'css' do
  filename = params[:splat].first
  scss filename.to_sym, :views => "#{settings.root}/assets/stylesheets"
end
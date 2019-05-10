require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    if !logged_in?
      erb :index
    else
      redirect "/users/#{current_user.id}"
    end
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def current_user
      User.find(session[:user_id]) if session[:user_id]
    end

  end

end

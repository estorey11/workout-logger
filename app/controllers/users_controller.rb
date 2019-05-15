require 'pry'

class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    erb :"/users/index.html"
  end

  # GET: /users/new
  get "/users/new" do
    erb :"/users/new.html"
  end

  # POST: /users
  post "/users" do
    if params[:username] == "" || User.find_by(username: params[:username])
      redirect "/"
    else

      @user = User.new(:username => params[:username], :password => params[:password])

      if @user.save
        session[:user_id] = @user.id
        redirect "/users/#{@user.id}"
      else
        redirect "/"
      end

    end
  end

  # GET: /users/5
  get "/users/:id" do
    if logged_in?
      @user=current_user
      @ordered_lifts=@user.exercises.order(weight: :desc)
      @best_lifts=[]
      @ordered_lifts.each do |lift|
        if !@best_lifts.any? {|best_lift| best_lift.name == lift.name}
          @best_lifts << lift
        end
      end
      erb :"/users/show.html"
    else
      redirect '/'
    end
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end

  post "/login" do
    @user = User.find_by(:username => params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.id}"
    else
      redirect "/logout"
    end
  end

  get "/logout" do
    session.destroy
    redirect '/'
  end

end

require 'pry'

class WorkoutsController < ApplicationController

  # GET: /workouts
  get "/workouts" do
    @user=current_user
    @workouts=Workout.all
    erb :"/workouts/index.html"
  end

  # GET: /workouts/new
  get "/workouts/new" do
    erb :"/workouts/new.html"
  end

  # POST: /workouts
  post "/workouts" do
    if params[:workout][:date] != ""
      @workout=Workout.new(date: params[:workout][:date], bodyweight: params[:workout][:bodyweight], user_id: current_user.id)
      @workout.save

      params[:workout][:exercises].each do |details|
        if details[:name]!= "" && details[:weight]!= "" && details[:reps]!= "" && details[:sets]!= ""
          exercise=Exercise.new(details)
          exercise.workout_id=@workout.id
          exercise.save
        end
      end
    end

    if logged_in?
      redirect "/users/#{current_user.id}"
    else
      redirect "/workouts"
    end

  end

  # GET: /workouts/5
  get "/workouts/:id" do
    @workout=Workout.find(params[:id])
    erb :"/workouts/show.html"
  end

  # GET: /workouts/5/edit
  get "/workouts/:id/edit" do
    @workout=Workout.find(params[:id])
    erb :"/workouts/edit.html"
  end

  # PATCH: /workouts/5
  patch "/workouts/:id" do

    @workout=Workout.find(params[:id])

    if params[:workout][:date] != "" && @workout.user == current_user
      @workout.date=params[:workout][:date]
      @workout.bodyweight=params[:workout][:bodyweight]
      @workout.save

      params[:workout][:exercises].each_with_index do |details, i|
        if details[:name]!= "" && details[:weight]!= "" && details[:reps]!= "" && details[:sets]!= ""

          if @workout.exercises[i]
            exercise=@workout.exercises[i]
            exercise.name=details[:name]
            exercise.weight=details[:weight]
            exercise.sets=details[:sets]
            exercise.reps=details[:reps]
            exercise.save
          else
            exercise=Exercise.new(details)
            exercise.workout_id=@workout.id
            exercise.save
          end

        end
      end
    end

    redirect "/workouts/#{@workout.id}"

  end

  # DELETE: /workouts/5/delete
  delete "/workouts/:id/delete" do
    @workout = Workout.find(params[:id])
      if @workout && @workout.user == current_user
        @tweet.delete
      end
    redirect "/workouts"
  end

end

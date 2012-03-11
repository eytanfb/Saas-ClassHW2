class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    remember_params
    user_settings = session[:remember]
    @all_ratings = Movie.ratings
    @chosen_ratings = user_settings[:ratings] ||= {}
    @movies = Movie.order(user_settings[:order])
    if @chosen_ratings.length > 0
      @movies = @movies.where(:rating => @chosen_ratings.keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  private
  
  def remember_params
    session[:remember] ||= {}
    old_user_settings = session[:remember]
    if params[:order] == old_user_settings[:order] and params[:ratings] == old_user_settings[:ratings]
      redirect_to movies_path
    end
    if params[:order].nil? 
      params[:order] = old_user_settings[:order]
    end
    if params[:ratings].nil?
      params[:ratings] = old_user_settings[:ratings]
    end
    enter_settings
    new_user_settings = session[:remember]
  end
  
  def enter_settings
    session[:remember] = {
      order: params[:order], 
      ratings: params[:ratings]
      }
  end

end

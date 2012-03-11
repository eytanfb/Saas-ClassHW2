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
    old_user_settings = session[:remember]
    if params[:order].nil? or params[:ratings].nil?
      params[:order] ||= old_user_settings[:order]
      params[:ratings] ||= old_user_settings[:ratings]
    session[:remember] = {
      order: params[:order], 
      ratings: params[:ratings]
      }
    new_user_settings = session[:remember]
    redirect_to movies_path(new_user_settings) and return
    end
    session[:remember] = {
      order: params[:order], 
      ratings: params[:ratings]
      }
    #if new_user_settings.nil?
     # redirect_to movies_path(new_user_settings) and return
    #end
  end

end

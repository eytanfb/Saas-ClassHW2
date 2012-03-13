class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    old_settings = session[:remember]
    if old_settings.nil?
      enter_settings
      new_user_settings = session[:remember]
      redirect_to movies_path(new_user_settings) and return
    end
    
    redirect = false
    if params[:order] == nil and old_settings[:order] != nil
       params[:order] = old_settings[:order]
       redirect = true
    end
    if params[:ratings] == nil and old_settings[:ratings] != nil
       params[:ratings] = old_settings[:ratings]
       redirect = true
    end
    
    if params[:ratings] != old_settings[:ratings] or params[:order] != old_settings[:order]
      new_user_settings = enter_settings
      redirect_to movies_path(new_user_settings) and return
    end
    
    if redirect
      enter_settings
      new_user_settings = session[:remember]
      redirect_to movies_path(new_user_settings) and return
    end
  
    enter_settings
    @all_ratings = Movie.ratings
    @chosen_ratings = old_settings[:ratings] ||= {}
    @movies = Movie.order(old_settings[:order])
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
  
  def enter_settings
    session[:remember] = {
      order: params[:order], 
      ratings: params[:ratings]
      }
  end

end

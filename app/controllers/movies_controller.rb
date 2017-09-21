class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Alter @sort and @ratings appropriately...
    @sort = session[:sort]
    @ratings = session[:ratings]
    
    @all_ratings = Movie.ratings
    ratingsList = params[:ratings_]
    if ratingsList
      @ratings = ratingsList.keys
    elsif !@ratings
      @ratings = @all_ratings
    end
    @movies = Movie.where({rating: @ratings})
    
    priority_sort = params[:sort]
    if priority_sort
      @movies.order!(@sort)
    end
    
    session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def sort
    last_sort = session[:sort]
    priority_sort = params[:sort]
    if priority_sort
      session[:sort] = priority_sort
      redirect_to movies_path(:sort => priority_sort)
    elsif @sort
      redirect_to movies_path(:sort => last_sort)
    else
      redirect_to movies_path
    end
  end
  
  def filter
    last_ratings = session[:ratings]
    ratingsList = params[:ratings_]
    byebug
    if ratingsList
      session[:ratings] = @ratings
      movies_path(:ratings_ => ratingsList)
    elsif !@ratings
      movies_path(:ratings_ => last_ratings)
    end
  end

end

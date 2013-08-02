class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    set_sort_by
    set_rating_filters
    @movies = Movie.
                where('rating IN (:ratings)', :ratings => @ratingFilters).order(@sort_by)
  end

  def set_sort_by
    if params[:sort_by] != nil
      @sort_by = params[:sort_by]
    else 
      @sort_by = session[:sort_by]
    end
    session[:sort_by] = @sort_by
  end

  def set_rating_filters
    @all_ratings = Movie.all_ratings

    if params[:ratings] != nil
      @ratingFilters = params[:ratings]
      if @ratingFilters.is_a? Hash
        @ratingFilters = @ratingFilters.keys
      end
    elsif session[:ratingFilters] != nil
      @ratingFilters = session[:ratingFilters]
    else
      @ratingFilters = @all_ratings
    end
    
    session[:ratingFilters] = @ratingFilters
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

end

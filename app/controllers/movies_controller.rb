class MoviesController < ApplicationController
   respond_to :html, :json
   
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    #@movies = Movie.find(:all)
    #@movies = Movie.find(:all, :order => (params[:sort]))
    #@movies = Movie.where(:rating => @filtered_ratings)
    #@all_ratings = Movie.all_ratings
    #@movies = Movie.scoped
    
    session_params = session.to_hash.slice('sort', 'ratings')
    
    if params.slice(:sort,:ratings).empty? && session_params.any?
      
      flash.keep
      redirect_to movies_path(session_params)
    end
    
    session[:sort] = params[:sort] if params[:sort].present? #if sort clicked, save session
    session[:ratings] = params[:ratings] if params[:ratings].present? #if ratings changed, save session
    
    @sort_field = session[:sort] # maps current sort and rating to variables to sort and filter
    @ratings = session[:ratings] || Movie::RATINGS
    
    @all_ratings = Movie::RATINGS
    @movies = Movie.order(@sort_field).filter_by_rating(@ratings)
    
    
    
    
    # @movies = Movie.order(:title) if params[:sort] == "title"
    # @movies = Movie.order(:release_date) if params[:sort] == "release_date"
    # if params[:sort] == 'title'
    #   @title_header = 'hilite'
    #   elsif params[:sort] == 'release_date'
    #     @release_date_header = 'hilite'
    # if params[:ratings]
    #   @movies = Movie.where(:rating => params[:ratings].keys).find(:all, :order => (params[:sort]))
    # end
    #   @sort_column = params[:sort]
    #   @all_ratings = Movie.all_ratings
    #   @set_ratings = params[:ratings]
      
      
      
      # if !@set_ratings
      #   @set_ratings = Hash.new
      # end
    #end
    # if params[:filter] == 'rating'
    #   @movies = Movie.where(:filter => rating)
    # end
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

end

class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index

      @all_ratings = Movie.all_ratings
      @which_to_check = params[:ratings]
      @which_to_click = params[:which_to_click]
      
      #first time to come in
      if @which_to_check == nil && @which_to_click == nil
        @which_to_check = Hash[@all_ratings.map {|rating| [rating,1]}]
      elsif @which_to_check == nil
      # uncheck all the checkboxes
        @which_to_check = session[:which_to_check]
      end

      p @which_to_check
      session[:which_to_check] = @which_to_check
      session[:which_to_click] = @which_to_click
      
      
      @movies = Movie.with_ratings(@which_to_check.keys)
      
      if @which_to_click == "movie_title"
        @movies = @movies.order(:title)
      end
      
      if @which_to_click == "release_date"
        @movies = @movies.order(:release_date)
      end
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path(:which_to_click => session[:which_to_click], :ratings => session[:which_to_check])
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
      redirect_to movies_path(:which_to_click => session[:which_to_click], :ratings => session[:which_to_check])
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end
class Movie < ActiveRecord::Base
  #attr_accessible :title, :rating, :description, :release_date

# def create
#     @movie = Movie.    

# def movie_params
#   params.require(:movie).permit(:title, :rating, :description, :release_date)
# def self.all_ratings
#   a = Array.new
#   self.select("rating").uniq.each{|x| a.push(x.rating)}
#   a.sort.uniq
# end

  RATINGS = %w[G PG PG-13 R]
  
  def self.filter_by_rating(ratings)
    where(arel_table[:rating].in(ratings))
  end

end

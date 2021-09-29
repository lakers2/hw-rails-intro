class Movie < ActiveRecord::Base
    def self.all_ratings
        return ['G','PG','PG-13','R']
    end
    
    def self.with_ratings(which_to_check)
        return Movie.where(:rating => which_to_check)
    end
end
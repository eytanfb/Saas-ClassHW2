class Movie < ActiveRecord::Base
  def Movie.ratings
    @ratings ||= ['G', 'PG', 'PG-13', 'R']
  end
end

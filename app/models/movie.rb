class Movie < ActiveRecord::Base
    @checked = ['G','PG','PG-13','R']
    @unchecked = []
    attr_accessor :checked
    
    def self.ratings
        ['G','PG','PG-13','R']
    end
    
    def self.check(rating)
        if !@checked.include?(rating)
            @checked += [rating]
            @checked.sort!
            @unchecked -= rating
        end
    end
    
    def self.uncheck(rating)
        if @checked.include?(rating)
            @checked -= rating
            @unchecked += rating
        end
    end
end

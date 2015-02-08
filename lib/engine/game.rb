module Engine

##
# The main game state class
class Game
    ##
    # Called periodicly
    def tick elapsed
        raise NotImplementedError
    end
end

end

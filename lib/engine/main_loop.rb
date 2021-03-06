#:nodoc:all#
require 'sdl2'
#:doc:#

module Engine
# This class handles polling for input, updates, and rendering
class MainLoop

    # The increment to update in 
    Quantum = 20

    # Creates a new main loop
    # @param game [Game] The game to play
    # @param renderer [Renderer] The renderer to render the `game` with 
    def initialize game, renderer
        @game = game
        @renderer = renderer
        @inputs = []
    end

    ##
    # Adds an input to be handled
    # @param input [Input] The input handler
    def add_input input
        @inputs.push input
        self
    end

    ##
    # Run the loop until the process quits
    def run
        @last = SDL2::get_ticks
        @updates = 0

        loop do
            handle_events
            @updates += since_last
            for _ in (0..@updates/Quantum) do
                @game.tick Quantum
            end

            @renderer.render @game if @updates > 10
            @updates %= Quantum

            sleep 1.0/1000
        end
    end

    private
    def handle_events
        while event = SDL2::Event.poll do
            @inputs.each {|input| input.handle_event event}
        end
    end

    def since_last
        now = SDL2::get_ticks
        delta = @last-now
        @last = now
        delta
    end
end
end

module Engine
class Renderer
    attr_reader :window
    def initialize window, *rest 
        @window = window
        @renderer = @window.create_renderer -1, SDL2::Renderer::Flags::ACCELERATED
        construct *rest
    end

    ##
    # When this method is called, the game should be rendered
    # @param game [Game] The game to render
    # This method MUST be implemented
    def render game
        raise NotImplementedError
    end

    protected

    # Draw the drawable at position (x,y)
    def place drawable, x,y
        drawn = drawable.draw self
        dst = SDL2::Rect.new x,y, drawn.w,drawn.h
        copy drawn,nil,dst
    end

    ##
    # This responds to everything an {SDL2::Renderer} does
    def method_missing(name, *args, &block)
        begin
            @renderer.send(name, *args, &block)
        rescue => ex
            p ex.methods
            p ex.message
            raise ex
        end
    end
end
end

SDL2.init SDL2::INIT_EVERYTHING
# Not all OpenGL/GLES implementations default to 32bit color
# When they don't, nothing resembling that you wanted is displayed
SDL2::GL.set_attribute(SDL2::GL::RED_SIZE, 8)
SDL2::GL.set_attribute(SDL2::GL::GREEN_SIZE, 8)
SDL2::GL.set_attribute(SDL2::GL::BLUE_SIZE, 8)
SDL2::GL.set_attribute(SDL2::GL::ALPHA_SIZE, 8)
SDL2::GL.set_attribute(SDL2::GL::DOUBLEBUFFER, 1)
SDL2::TTF::init


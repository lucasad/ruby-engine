module Engine
class Renderer
    def initialize window

        @window = window
        @renderer = @window.create_renderer -1, SDL2::Renderer::Flags::ACCELERATED
    end

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

    def method_missing(name, *args, &block)
        @renderer.send(name, *args, &block)
    end
end
end

SDL2.init SDL2::INIT_EVERYTHING
# Not all OpenGL/GLES implementations default to 32bit color
SDL2::GL.set_attribute(SDL2::GL::RED_SIZE, 8)
SDL2::GL.set_attribute(SDL2::GL::GREEN_SIZE, 8)
SDL2::GL.set_attribute(SDL2::GL::BLUE_SIZE, 8)
SDL2::GL.set_attribute(SDL2::GL::ALPHA_SIZE, 8)
SDL2::GL.set_attribute(SDL2::GL::DOUBLEBUFFER, 1)
SDL2::TTF::init


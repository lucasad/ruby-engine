module Engine
module Drawable
    attr_reader :w, :h

    ##
    # Draw the item into a texture
    def draw renderer
        raise NotImplementedError
    end


    ##
    # Re-render
    def render
        @clean = false
    end

    
    ##
    # Place the texture at the (x,y) position in the renderer
    def place renderer, texture, x,y
        tw,th = texture.w, texture.h
        dst = SDL2::Rect.new x,y, tw,th 
        renderer.copy texture, nil, dst
        @texture
    end

    ##
    # Place the texture in the center of the renderer
    def place_center renderer, texture
        tw,th = texture.w, texture.h
        x = (w-tw)/2
        y = (h-th)/2
        place renderer, texture, x,y
        @texture
    end

    #def _draw renderer
    #        @texture ||= renderer.create_texture SDL2::PixelFormat::ARGB8888, SDL2::Texture::ACCESS_TARGET, w,h
    #        unless @clean then 
    #            old_target = renderer.render_target
    #            renderer.render_target = @texture
    #            draw renderer 
    #            renderer.render_target = old_target
    #            @clean = true
    #        end
    #        @texture
    #end

    ##
    # Do the dirty work
    # Wraps the draw method so that it handles changing out the renderer's targets and creates a default texture of :w,:h
    def self.included klass
        _draw = klass.instance_method :draw
        klass.send :define_method, :draw, proc { |renderer| 
            @texture ||= renderer.create_texture SDL2::PixelFormat::ARGB8888, SDL2::Texture::ACCESS_TARGET, w,h
            unless @clean then 
                old_target = renderer.render_target
                renderer.render_target = @texture
                _draw.bind(self).call renderer 
                renderer.render_target = old_target
                @clean = true
            end
            @texture
        }   
    end 

end
end    


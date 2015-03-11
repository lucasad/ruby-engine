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

    ##
    # Do the dirty work
    # Wraps the draw method so that it handles changing out the renderer's targets and creates a default texture of :w,:h
    # Overrides the dup method so that a new texture is used
    def self.included klass
        klass.class_exec do
            _draw = instance_method :draw
            define_method :draw do |renderer| 
                unless @texture then
                    @texture = renderer.create_texture SDL2::PixelFormat::ARGB8888, SDL2::Texture::ACCESS_TARGET, w,h
                    @clean = false
                end
                unless @clean then 
                    old_target = renderer.render_target
                    renderer.render_target = @texture
                    _draw.bind(self).call renderer 
                    renderer.render_target = old_target
                    @clean = true
                end
                @texture
            end 

            _dup = instance_method :dup
            define_method :dup do
                new = _dup.bind(self).call
                new.instance_variable_set :@texture, nil 
                return new
            end
        end
    end 

end
end    


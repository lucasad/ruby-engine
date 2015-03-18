require 'engine/drawable'
require 'sdl2'

module Engine
class Text
    #@!attribute [rw] text
    #   The text that is rendered
    #@!attribute [r] width
    #   The width of the rendered text
    #@!attribute [r] height
    #   The height of the rendered text
    #@!attribute [rw] color
    #   The color of the text
    attr_reader :text, :w, :h, :color

    SDL2::TTF.init
    Default = SDL2::TTF::open "/usr/share/fonts/dejavu/DejaVuSansMono-Bold.ttf", 20

    ##
    # Create a text object
    # @param [String] text The text to render
    # @param [Hash] kwargs
    # @option kwargs [Color] :color The text's color, defaults to black
    # @option kwargs [SDL2::TTF] :font The font to use, default to Text::Default
    def initialize text=" ", **kwargs
        @color = kwargs[:color] || [0,0,0]
        @font = kwargs[:font] || Default
        self.text= text
    end

    ##
    # Update the text in the object
    def text= text
        @text = text
        @w,@h = @font.size_text text
        @surface = @font.render_blended text, @color
        render
        @text
    end

    def color= color
        @color = color
        render
    end

    def render
        @texture = nil
    end

    def draw renderer
        @texture ||= renderer.create_texture_from @surface
    end
end
end

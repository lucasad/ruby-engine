#:nodoc:#
require 'sdl2'
#:doc:#

module Engine
    ##
    # The class to inherit for input handling
    class Input
        ##
        # Handles the SDL2::Event passed to it
        def handle_event event
            case event
                when SDL2::Event::MouseMotion
                _mouse_motion event 
                when SDL2::Event::MouseButtonDown
                _mouse_press event
                when SDL2::Event::MouseButtonUp
                _mouse_release event
                when SDL2::Event::MouseWheel
                _mouse_wheel event
                when SDL2::Event::TouchFinger
                _touch_finger event
                when SDL2::Event::Keyboard
                _keyboard event
                when SDL2::Event::TextInput
                _text_input event
                when SDL2::Event::Quit
                _quit event
                when SDL2::Event::Window
                _window event
                else
                p event
            end
        end

        private
        def _mouse_motion event;end
        def _mouse_button event;end
        def _mouse_wheel event;end
        def _touch_finger event;end
        def _keyboard event;end
        def _text_input event;end
        def _quit event;end
        def _window event;end
    public
    ##
    # A mixin to handle mouse input
    module MouseInput
        protected
        ##
        # Initialize the mouse input
        # which refers to which mouse to handle input for
        def mouse_init which=0
            @which=which
            @pressed = {}
        end

        #:nodoc:#
        def _mouse_motion event
            return unless event.which==@which 
            @x,@y = event.x,event.y
            mouse_move event.xrel,event.yrel
        end
    
        def _mouse_button event
            p event
            return unless event.which==@which 
            @x,@y = event.x,event.y
            button = event.button
        end
        def _mouse_press event
            return unless _mouse_button event
            @pressed[event.button] = true
            mouse_press event.button
        end
        def _mouse_release event
            return unless _mouse_button event
            @pressed[event.button] = false
            mouse_release event.button
        end
        def _mouse_wheel event    
            return unless event.which==@which 
            mouse_scroll event.x,event.y
        end
        #:doc:#

        ##
        # Mouse moved
        def mouse_move dx,dy
        end
        ##
        # Mouse button pressed
        def mouse_press button
        end
        ##
        # Mouse button released
        def mouse_release button
        end
        ##
        # Scrollwheel moved
        def mouse_scroll x,y
        end
    end


    ##
    # The mixin for touch event handling
    module TouchInput
        protected
        def touch_init
            @fingers = {}
        end

        #:nodoc:#
        def _finger_motion event
            finger,x,y,dx,dy = event.finger_id, event.x,event.y,event.dx,event.dy
            @fingers[finger] = x,y
            finger_motion finger,dx,dy
        end

        def _finger_down event
            finger,x,y,pressure = event.finger, event.x,event.y, event.pressure
            @fingers[finger] = x,y
            finger_down finger pressure
        end

        def _finger_up event
            finger,x,y = event.finger, event.x,event.y
            @fingers[finger] = x,y
            finger_up finger
            @fingers.delete finger
        end
        #:doc:#

        ##
        # Called when a finger moves
        def finger_motion finger,dy,dx
        end

        ##
        # Called when the {finger} is pressed down with {pressure} 
        def finger_down finger, pressure
        end
        ##
        # Called when a finger is released
        def finger_up finger
        end

        ##
        # Get the absolute position of a finger
        def finger_position finger
            @fingers[finger]
        end
    end

    #:nodoc:#
    module WindowEvents
        NONE = 0
        SHOWN = 1
        HIDDEN = 2
        EXPOSED = 3

        MOVED = 4

        RESIZED = 5
        SIZE_CHANGED =6
        MINIMIZED = 7
        MAXIMIZED = 8
        RESTORED = 9

        ENTER = 10
        LEAVE = 11
        FOCUS_GAINED = 12
        FOCUS_LOST = 13
        CLOSE = 14
    end
    #:doc:#

    ##
    # A mixin for window input
    module WindowInput
        ##
        # Sets the window to check input for
        # It MUST be called during the class's initialization
        def window_init window
            @window_id = window.window_id
        end
    
        #:nodoc:#
        include WindowEvents
        protected
        def _window event
            return unless event.window_id == @window_id 
            case event.event
            when SHOWN
            window_shown
            when HIDDEN
            window_hidden
            when EXPOSED
            window_exposed

            when MOVED
            window_moved event.data1, event.data2
            when RESIZED
            window_resize event.data1, event.data2
            when SIZE_CHANGED
            window_resized event.data1, event.data2
            when MINIMIZED
            window_minimized
            when MAXIMIZED
            window_maximized
            when RESTORED
            window_restored

            when ENTER
            window_enter
            when LEAVE
            window_leave
            when FOCUS_GAINED
            window_focus_gained
            when FOCUS_LOST
            window_focus_lost
            
            when CLOSE
            window_close
            end
        end
        #:doc:#
        protected
        ##
        # Called when the window has been shown
        def window_shown
        end

        ##
        # Called when the window has been hidden
        def window_hidden
        end

        ##
        # Called when the window is exposed
        # this happens when something that was covering all or part of the window has been moved and is no longer covering it
        def window_exposed
        end

        ##
        # Called when the window has been moved
        def window_moved x,y
        end

        ##
        # Called when something wants to resize the window 
        def window_resize new_width, new_height
        end

        ##
        # Called after the window has been resized
        def window_resized width, height
        end 

        ##
        # Called when the window has been maximised
        def window_maximized
        end

        ##
        # Called when the window has been minimized
        def window_minimized
        end

        ##
        # Called when the window has been restored
        def window_restored
        end

        def window_enter
        end
        def window_leave
        end
        def window_focus_gained
        end
        def window_focus_lost
        end

        ##
        # Called when the close button is pressed
        def window_close
        end
    end
end
end

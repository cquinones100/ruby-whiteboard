# frozen_string_literal: true
require 'ostruct'

module Actions
  class Drawing
    attr_writer :window

    def initialize
      @pen_down = false
      @engaged = false
      @window = nil
      @objects = []
    end

    def engage?(event)
      engaged? || event.key == 'd'
    end

    def engage
      @engaged = true
    end

    def disengage
      @engaged = false
    end

    def engaged?
      @engaged
    end

    def pen_down?
      @pen_down
    end

    def to_s
      'Drawing'
    end

    def draw
      current_x, current_y = window.mouse_coordinates

      objects << window.line.new(
        x1: @last_x || current_x, y1: @last_y || current_y,
        x2: current_x, y2: current_y,
        width: 5,
        color: 'black'
      )

      [current_x, current_y]
    end

    def register_event_handlers
      register_mouse_down_handler
      register_mouse_move_handler
      register_key_held_handler
      register_key_up_handler
    end

    def clear_objects
      objects.each(&:remove)
    end

    private

    attr_reader :window, :objects

    def register_mouse_down_handler
      window.on :mouse_down do |event|
        if put_pen_down?
          put_pen_down(event)
        else
          lift_pen
        end
      end
    end

    def register_mouse_move_handler
      window.on :mouse_move do
        @last_x, @last_y = draw if draw?
      end
    end

    def register_key_held_handler
      window.on :key_held do |event|
        if put_pen_down? && event.key == 'space'
          x, y = window.mouse_coordinates

          put_pen_down(OpenStruct.new(x: x, y: y))
        end
      end
    end

    def register_key_up_handler
      window.on :key_up do |event|
        lift_pen if pen_down? && event.key == 'space'
      end
    end

    def put_pen_down(event)
      @pen_down = true
      @start_coordinates = [event.x, event.y]
    end

    def lift_pen
      @last_x = nil
      @last_y = nil
      @pen_down = false
    end

    def draw?
      engaged? && pen_down?
    end

    def put_pen_down?
      engaged? && !pen_down?
    end

    def lift_pen?
      engaged? && pen_down?
    end
  end
end

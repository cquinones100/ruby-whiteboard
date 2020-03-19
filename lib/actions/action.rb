module Actions
  class Action
    attr_writer :window

    def initialize
      @window = nil
      @objects = []
      @engaged = false
    end

    def engage?
      engaged?
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

    def to_s
      raise 'Child Action must define #to_s'
    end

    def clear_objects
      objects.each(&:remove)
    end

    def register_event_handlers
      raise 'Child Action must define #register_event_handlers'
    end

    def on(*args, &block)
      window.on(*args, &block)
    end

    def mouse_coordinates
      window.mouse_coordinates
    end

    def line
      window.line
    end

    def text
      window.text
    end

    private

    attr_reader :window, :objects

    def current_x
      mouse_coordinates[0]
    end

    def current_y
      mouse_coordinates[1]
    end
  end
end

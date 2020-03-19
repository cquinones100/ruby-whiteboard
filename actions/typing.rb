# frozen_string_literal: true

require './actions/action'
require './helpers/typer'

module Actions
  class Typing < Action
    def initialize
      super

      @started = false
      @typers = []
    end

    def engage?(event)
      super() || event.key == 't'
    end

    def disengage
      super

      @started = false
    end

    def to_s
      'Typing'
    end

    def register_event_handlers
      on :key_down do |event|
        draw(event.key) if engaged?
      end

      on :mouse_move do
        @started = false
      end

      on :key_up do |event|
        @typer.handle_key_up(event.key) if engaged? && @typer
      end
    end

    def create_typer(x: current_x, y: current_y)
      @typers << Helpers::Typer.new(x: x, y: y, base: self)
      @typer = typers.last

      objects << @typer.text
    end

    private

    attr_reader :typers, :typer

    def started?
      @started
    end

    def draw(key)
      create_typer unless started?

      @started = true

      @typer.add(key)
    end
  end
end

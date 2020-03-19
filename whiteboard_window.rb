# frozen_string_literal: true

require 'ruby2d'

class WhiteboardWindow
  BACKGROUND = 'white'
  HEIGHT = 1000
  TITLE = 'Ruby Whiteboard'
  WIDTH = 1000

  def initialize
    @actions = []
    @engaged_action = nil
    @rendered_action_text = Text.new(
      action_text,
      x: 10, y: 10,
      size: 20,
      color: 'black'
    )
  end

  def build(&block)
    set width: 1000, height: 1000
    set title: 'Ruby Whiteboard'
    set background: 'white'

    instance_eval(&block) if block_given?
    actions.each(&:register_event_handlers)

    on :key_down do |event|
      puts event.key
      case event.key
      when 'c'
        actions.each(&:clear_objects)
      when 'escape'
        disengage
      else
        toggle_action_engage(event)
      end
    end

    show
  end

  def on(*args, &block)
    Window.on(*args, &block)
  end

  def mouse_coordinates
    [get(:mouse_x), get(:mouse_y)]
  end

  def line
    Line
  end

  private

  attr_reader :actions

  def toggle_action_engage(event)
    new_engaged_action = actions.detect do |action_instance|
      action_instance.engage?(event)
    end

    @engaged_action&.disengage if new_engaged_action != @engaged_action
    new_engaged_action&.engage

    @engaged_action = new_engaged_action
    @rendered_action_text.text = action_text
  end

  def disengage
    @engaged_action.disengage
    @engaged_action = nil
    @rendered_action_text.text = action_text
  end

  def action(action_class)
    action_instance = action_class.new
    action_instance.window = self

    @actions << action_instance
  end

  def set(*args)
    Window.set(*args)
  end

  def show
    Window.show
  end

  def get(*args)
    Window.get(*args)
  end

  def action_text
    "Action: #{@engaged_action&.to_s || 'none'}"
  end
end

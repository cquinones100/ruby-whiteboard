# frozen_string_literal: true

module Helpers
  class Typer < String
    attr_reader :base, :self, :text

    def initialize(base:, x:, y:, string: '')
      @base = base
      self << string

      @text = base.text.new(self, x: x, y: y, size: 20, color: 'black')
      @shift_held = false
    end

    def handle_key_up(key)
      release_shift if shift_key?(key)
    end

    def add(other)
      press_shift if shift_key?(other)

      if backspace?(other)
        press_backspace
      else
        self << key(other)
      end

      text.text = self
    end

    private

    def backspace?(other)
      other == 'backspace'
    end

    def press_backspace
      string = self[0...-1]

      delete!(self)

      self << string
    end

    def shift_held?
      @shift_held
    end

    def press_shift
      @shift_held = true
    end

    def release_shift
      @shift_held = false
    end

    def key(other)
      return '' if shift_key?(other)

      case other
      when 'space'
        ' '
      when 'escape'
        ''
      when 'return'
        press_return

        ''
      else
        if shift_held?
          shift(other)
        else
          other
        end
      end
    end

    def shift(other)
      return other if (other =~ /[a-z]/).nil?

      other.capitalize
    end

    def shift_key?(other)
      ['right shift', 'left shift'].include?(other)
    end

    def press_return
      base.create_typer(x: text.x, y: text.y + text.height)
    end
  end
end

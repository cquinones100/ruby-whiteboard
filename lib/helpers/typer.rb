# frozen_string_literal: true
require './lib/helpers/border'

module Helpers
  class Typer < String
    KEYS_TO_SHIFT = {
      '1' => '!', '2' => '@', '3' => '#', '4' => '$', '5' => '%', '6' => '^',
      '7' => '*', '8' => '*', '9' => '(', '0' => ')', '-' => '_', '=' => '+',
      '`' => '~', ',' => '<', '.' => '>', '/' => '?', ';' => ':', "'" => '"',
      '[' => '{', ']' => '}', '\\' => '|'
    }
      .freeze

    attr_reader :base, :text

    def initialize(base:, x:, y:, string: '')
      @base = base
      self << string

      @text = base.text.new(self, x: x, y: y, size: 20, color: 'black')
      @border = Border.new(base: @text)
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
      border.update
    end

    private

    attr_reader :border

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
      return KEYS_TO_SHIFT[other] if (other =~ /[a-z]/).nil?

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

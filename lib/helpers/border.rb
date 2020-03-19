# frozen_string_literal: true
require 'ruby2d'

module Helpers
  class Border
    def initialize(base:)
      @base = base
      @top = Line.new(color: 'black')
      @bottom = Line.new(color: 'black')

      update
    end

    def update
      update_top
      update_bottom
    end

    private

    attr_reader :top, :bottom, :base

    def update_top
      top.x1 = base.x
      top.y1 = base.y
      top.x2 = base.x + base.width
      top.y2 = base.y
    end

    def update_bottom
      bottom.x1 = base.x
      bottom.y1 = base.y + base.height
      bottom.x2 = base.x + base.width
      bottom.y2 = base.y + base.height
    end
  end
end

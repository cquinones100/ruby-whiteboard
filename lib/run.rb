# frozen_string_literal: true

require './lib/whiteboard_window'
require './lib/actions/drawing'
require './lib/actions/typing'

WhiteboardWindow.new.build do
  action Actions::Drawing
  action Actions::Typing
end

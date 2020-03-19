# frozen_string_literal: true

require './whiteboard_window'
require './actions/drawing'
require './actions/typing'

WhiteboardWindow.new.build do
  action Actions::Drawing
  action Actions::Typing
end

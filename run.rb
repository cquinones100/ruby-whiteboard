# frozen_string_literal: true

require './whiteboard_window'
require './actions/drawing'

WhiteboardWindow.new.build do
  action Actions::Drawing
end

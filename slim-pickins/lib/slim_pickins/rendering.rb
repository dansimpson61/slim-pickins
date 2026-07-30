# frozen_string_literal: true

module SlimPickins
  # How a renderable object reaches the view it is rendering into.
  #
  # Shared by the two kinds of thing that produce markup: a Component, which
  # a helper calls, and a Word, which a template speaks.
  module Rendering
    # Renders in the context of a view, which supplies sp_tag and capture.
    def render_in(view)
      @view = view
      render
    end

    private

    attr_reader :view

    def tag(*args, **opts, &block) = view.sp_tag(*args, **opts, &block)
    def safe(value) = view.sp_safe(value)
  end
end

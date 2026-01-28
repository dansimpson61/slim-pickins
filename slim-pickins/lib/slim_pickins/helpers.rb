# frozen_string_literal: true

module SlimPickins
  module Helpers
    require_relative "helpers/base_helper"
    require_relative "helpers/layout_helper"
    require_relative "helpers/interaction_helper"
    require_relative "helpers/form_helper"
    require_relative "helpers/list_helper"

    include BaseHelper
    include LayoutHelper
    include InteractionHelper
    include FormHelper
    include ListHelper
  end
end

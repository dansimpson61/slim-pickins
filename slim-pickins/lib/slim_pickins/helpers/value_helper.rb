# frozen_string_literal: true

module SlimPickins
  module Helpers
    # Values, written the way a reader expects to see them.
    module ValueHelper
      # An amount of money.
      #
      #   ui_money(2_000_000)          # => "$2,000,000.00"
      #   ui_money(-6_400)             # => "-$6,400.00"
      #   ui_money(1_300, sign: true)  # => "+ $1,300.00"
      #   ui_money(-2_200, sign: true) # => "- $2,200.00"
      #
      # The plain form is what `Intl.NumberFormat` renders for USD, which is
      # what this app's own controllers have always shown. `sign:` is for a
      # ledger, where whether an amount came in or went out is the point, and
      # a bare minus would bury it.
      def ui_money(amount, sign: false)
        value = amount.to_f
        figure = "$#{sp_separated(format('%.2f', value.abs))}"

        return "#{value.negative? ? '-' : '+'} #{figure}" if sign

        value.negative? ? "-#{figure}" : figure
      end

      private

      # "2000000.00" -> "2,000,000.00"
      def sp_separated(digits)
        whole, fraction = digits.split(".")

        [whole.reverse.scan(/\d{1,3}/).join(",").reverse, fraction].join(".")
      end
    end
  end
end

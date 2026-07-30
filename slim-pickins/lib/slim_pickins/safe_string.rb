# frozen_string_literal: true

module SlimPickins
  # A String already known to be markup.
  #
  # Components and helpers return these, so nesting one inside another passes
  # through untouched, while a plain String -- anything from a user, a
  # database, or a template author writing prose -- is escaped.
  #
  # Ruby drops the subclass across +, join, and interpolation, so safety is
  # never inferred from composition. Whatever composes, re-marks.
  class SafeString < String
    def html_safe?
      true
    end
  end
end

# Escaping must be decided in one place: by the value, not by which sigil the
# template author typed. Slim's `=` escapes and `==` does not, which made the
# syntax a second source of truth. Teaching String the predicate lets Slim's
# Escapable filter defer to the value instead (see `use_html_safe` below), so
# `=` becomes correct for markup and data alike.
#
# It goes on Object, not String: Temple's escape_html_safe asks the original
# value as well as its to_s, so `= account_id` on an Integer would otherwise
# raise. ActiveSupport puts it here for the same reason.
#
# Never clobber ActiveSupport's version.
class Object
  def html_safe?
    false
  end unless method_defined?(:html_safe?)
end

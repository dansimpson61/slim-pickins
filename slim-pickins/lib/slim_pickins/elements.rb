# frozen_string_literal: true

module SlimPickins
  # The tag names a template is allowed to write without meaning a word.
  #
  # Views speak vocabulary; the handful of elements below are the ones a
  # template still writes directly -- the document frame, text, forms, and the
  # SVG a hand-drawn icon needs. Anything outside this list and outside the
  # vocabulary is a misspelling, and Grammar says so rather than letting the
  # browser silently ignore an element it has never heard of.
  ELEMENTS = %w[
    html head body title base link meta style script noscript template slot

    section nav article aside header footer address main
    h1 h2 h3 h4 h5 h6
    p hr pre blockquote ol ul li dl dt dd figure figcaption div

    a em strong small s cite q dfn abbr ruby rt rp data time code var samp kbd
    sub sup i b u mark bdi bdo span br wbr ins del

    picture source img iframe embed object param video audio track map area

    table caption colgroup col tbody thead tfoot tr td th

    form label input button select datalist optgroup option textarea output
    progress meter fieldset legend

    details summary dialog canvas

    svg path circle rect line polyline polygon g defs use text tspan ellipse
  ].to_set.freeze
end

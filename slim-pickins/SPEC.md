# Slim-Pickins — Spec

A front-end DSL for Sinatra + Slim. Templates say what they mean; the HTML,
the data attributes, and the JavaScript stay out of sight.

## Mission

Make abide pleasant to build. Nothing else.

This is the **V in MVC**, taken seriously — a presentation layer with its own
vocabulary, so views stop reaching for HTML and controllers stop formatting.

## Audience

One person. This is not a public gem and need not behave like one: no
deprecation cycles, no semver pressure, no users to break. Redesign freely.

## The contract with abide

abide expresses its front end **exclusively** in this vocabulary. That is the
defining constraint, and it cuts both ways:

- Any presentation concern abide has, this library must be able to say.
- Anything it cannot say is a gap to close here — never a reason for abide to
  fall back to raw HTML.

**Promotion is immediate.** If abide needs it in a view now, it becomes
vocabulary now. Waiting for a second occurrence would force abide to break the
rule in the meantime.

**Generalisation waits.** A first implementation may be shaped by exactly one
caller. The second caller is what forces a general API. Never design for
imagined ones.

## Boundaries

1. Dependencies point one way: views → helpers → domain. Never the reverse.
   The domain does not know that presentation exists.
2. Controllers pass data, not markup.
3. Views carry no inline `style=` and no raw HTML structure. Framework classes
   such as `.sp-stack` are vocabulary, and fine.
4. Views never hand-write `data-*` for **framework** behaviour — that is the
   emitting helper's job. An app wiring a controller of its own is legitimate;
   the demo does so for `sp-toast-manager`, `sp-remove`, and `sp-playground`.

## Surface

Helpers, via `register SlimPickins`:

| Helper | Renders | Controller |
|---|---|---|
| `sp_tag` | primitive tag builder; everything else uses it | — |
| `ui_card` | `<article class="sp-card">`, optional header | — |
| `ui_flash` | self-dismissing message | `sp-flash` |
| `ui_toggle_panel` | native `<details>` | — |
| `ui_button` | `<button>`, or `<a>` when given `href:` | — |
| `ui_text_field` | edit-in-place field | `sp-inline-edit` |
| `ui_sortable_list` / `ui_sortable_item` | drag-orderable list | `sp-sortable` |
| `ui_table` | data table from headers and rows | — |
| `ui_code` | source shown literally; escaped | — |
| `ui_well` | inset region for previews | — |
| `ui_badge` | round status indicator | — |

Layout is expressed in classes rather than helpers, since views write them
directly: `.sp-stack` and `.sp-cluster` with `--tight` / `--loose` / `--start`
/ `--between`, plus `.sp-grow`, `.sp-inset`, `.sp-nav`, and `.sp-page`.

Assets, served from the gem by `AssetMiddleware` at `/assets`:

- `assets/stylesheets/slim-pickins.css` — tokens and component styles
- `assets/js/slim_pickins.js` — `registerSlimPickins(application)`

## Rules

1. A controller exists only if a helper emits it. No orphan behaviour.
2. Helpers return HTML strings. No template files, no engine.
3. No build step. Ever.
4. The consumer supplies Stimulus and SortableJS through an import map; the
   library imports them as bare specifiers.
5. The demo consumes the library through `/assets` exactly as abide does, and
   obeys the same rules. It is the reference consumer, not a special case.

## Not this

Public distribution. A component library. Client-side state. An SPA.
Anything abide has not asked for.

## Stack

Ruby ≥ 2.7.8 · Sinatra 4 · Rack 3 · Slim 5 · Stimulus 3 (supplied by consumer)

## Known gaps

- **No icon vocabulary.** `index.slim` passes a raw inline SVG as button text.
  Needs a `ui_icon` before abide ports, which uses icons throughout.
- **`ui_toggle_panel` takes its title as a string**, so a rich title must be
  composed by concatenating helper calls in the view. It should accept a
  block. `status.slim` is the evidence.
- Helper content is not HTML-escaped; `escape_attr` handles `"` only, and only
  `ui_code` escapes its content. Any other value containing `&`, `<`, or `>`
  renders wrong.
- `sp_tag` emits `<div />` for nil content — invalid for non-void elements.
- The docs playground (`POST /docs/render`) executes arbitrary Ruby. Local
  tool only; never deploy it.

## Done looks like

Zero inline `style=` in any consuming view, and no hand-written `data-*` for
framework behaviour. Checkable mechanically, in the rendered DOM as well as
the templates.

The demo reached this on 2026-07-29: 113 inline styles to 0, verified as
0 elements carrying a `style` attribute across every page. abide is next.

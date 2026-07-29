# Slim-Pickins — Spec

A front-end DSL for Sinatra + Slim. Templates say what they mean; the HTML,
the data attributes, and the JavaScript stay out of sight.

## Mission

Make abide pleasant to build. Nothing else.

## Audience

One person. This is not a public gem and need not behave like one — no
deprecation cycles, no semver pressure, no users to break. Redesign freely.

## Relationship to abide

abide is the only consumer and the only source of requirements. A pattern
earns a place here once abide has needed it **twice**. Until then it stays
application code.

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

Assets, served from the gem by `AssetMiddleware` at `/assets`:

- `assets/stylesheets/slim-pickins.css` — tokens and component styles
- `assets/js/slim_pickins.js` — `registerSlimPickins(application)`

## Rules

1. A controller exists only if a helper emits it. No orphan behaviour.
2. Helpers return HTML strings. No template files, no engine.
3. No build step. Ever.
4. The consumer supplies Stimulus and SortableJS through an import map; the
   library imports them as bare specifiers.
5. The demo app consumes the library through `/assets` exactly as abide does,
   so a packaging gap breaks the demo too instead of hiding there.

## Not this

Public distribution. A component library. Client-side state. An SPA.
Anything abide has not asked for.

## Stack

Ruby ≥ 2.7.8 · Sinatra 4 · Rack 3 · Slim 5 · Stimulus 3 (supplied by consumer)

## Known gaps

- Helper content is not HTML-escaped; `escape_attr` handles `"` only. Any
  value containing `&`, `<`, or `>` renders wrong.
- `sp_tag` emits `<div />` for nil content — invalid for non-void elements.
- The docs playground (`POST /docs/render`) executes arbitrary Ruby. Local
  tool only; never deploy it.

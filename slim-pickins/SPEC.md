# Slim-Pickins — Spec

Governed by [the Ode to Joy](../ODE_TO_JOY.md). Where this spec and the Ode
disagree, the Ode wins and this spec is wrong.

A front-end DSL for Sinatra + Slim. Templates say what they mean; the HTML,
the data attributes, and the JavaScript stay out of sight.

## Mission

Make joyful Ruby front-ends pleasant to build. A general-purpose front-end DSL —
abide was the first consumer, not the only one.

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

## What a component is

One object that knows its own name. The class declares the name once; the CSS
class, the Stimulus identifier, and the two asset files are **derived** from
it, so there is no second list to keep in agreement.

```
lib/slim_pickins/components/flash.rb   # renders it; declares needs_controller
assets/components/flash.css            # appearance only
assets/components/flash.js             # behaviour only
```

`Component.registry` is populated by walking `components/`, and it drives the
stylesheet, the controller registration, and the completeness audit. Adding a
component is one file, not an entry in three places.

Templates never see the object. A helper is the façade, and the DSL is
unchanged: `= ui_flash :notice, "Welcome"`.

All fifteen are components: `badge`, `btn`, `card`, `code`, `field`,
`field-group`, `flash`, `icon`, `modal`, `pill`, `sortable-item`,
`sortable-list`, `table`, `toggle-panel`, `well`.

The slug is derived from the class name; declare it explicitly (`slug "btn"`)
only to keep an established name. Either way it is written once.

**The controller identifier is the CSS class.** There is no second string to
keep in agreement, which is why `sp-inline-edit` became `sp-field` and
`sp-sortable` became `sp-sortable-list` — those were names that agreed with
nothing.

What stays in the base stylesheet is *vocabulary*, not components: tokens,
typography, `.sp-stack`, `.sp-cluster`, `.sp-grid`, `.sp-list`, `.sp-input`,
`.sp-nav`, `.sp-page`, and the text and layout utilities.

## Surface

Helpers, via `register SlimPickins`:

| Helper | Renders | Controller |
|---|---|---|
| `sp_tag` | primitive tag builder; everything else uses it | — |
| `sp_safe` | vouches for a String that really is markup | — |
| `ui_card` | `<article class="sp-card">`, optional header | — |
| `ui_flash` | self-dismissing message | `sp-flash` |
| `ui_toggle_panel` | native `<details>` | — |
| `ui_button` | `<button>`, or `<a>` when given `href:` | — |
| `ui_text_field` | edit-in-place field; `method:` picks the verb | `sp-inline-edit` |
| `ui_sortable_list` / `ui_sortable_item` | drag-orderable list | `sp-sortable` |
| `ui_modal` / `ui_modal_trigger` | dialog and its opener | `sp-modal` |
| `ui_table` | data table from headers and rows | — |
| `ui_code` | source shown literally; escaped | — |
| `ui_icon` | inline SVG from a small built-in set | — |
| `ui_field` | labelled form control | — |
| `ui_pill` | small text pill | — |
| `ui_well` | inset region for previews | — |
| `ui_badge` | round status indicator | — |
| `ui_summary` | rich summary line for a toggle panel | — |
| `ui_money` | an amount: `$2,000,000.00`, or `+ $1,300.00` with `sign:` | — |

Layout is expressed in classes rather than helpers, since views write them
directly: `.sp-stack` and `.sp-cluster` with `--tight` / `--loose` / `--start`
/ `--between`, plus `.sp-grow`, `.sp-inset`, `.sp-nav`, `.sp-page`, and
`.sp-list` / `.sp-list__item` for a list of rows that does nothing.

Assets, served from the gem by `AssetMiddleware` at `/assets`:

- `assets/stylesheets/slim-pickins.css` — tokens and component styles
- `assets/js/slim_pickins.js` — `registerSlimPickins(application)`

## Rules

1. A controller exists only if a helper emits it. No orphan behaviour.
2. **An affordance may not outlive its behaviour.** A grab cursor, a grip, a
   hover lift — anything that invites an interaction — is scoped in CSS to the
   controller that answers it, e.g. `[data-controller~="sp-sortable"] .sp-sortable-item`.
   Take the class without the helper and it degrades to the plain look rather
   than promising something the page cannot do. Styling that lies is worse
   than styling that is missing.
3. Helpers return HTML strings. No template files, no engine.
4. No build step. Ever.
5. The consumer supplies Stimulus and SortableJS through an import map; the
   library imports them as bare specifiers.
6. The demo consumes the library through `/assets` exactly as abide does, and
   obeys the same rules. It is the reference consumer, not a special case.
7. **Content is escaped by default.** Helpers return a `SafeString`, so nesting
   one inside another passes through untouched, while a plain String — from a
   user, a database, a template author writing prose — is escaped on the way
   in. Attribute values are always escaped. Block content is markup by
   construction and is trusted. Vouch for a literal String with `sp_safe`.
   Ruby drops the subclass across `+`, `join`, and interpolation, so safety is
   never inferred: a helper that composes strings re-marks the result itself.

## Not this

Public distribution. A component library. Client-side state. An SPA.
Anything abide has not asked for.

## Running it

```
cd slim-pickins
bundle install
bin/puma -p 9292
```

Then <http://localhost:9292> for the demo, `/docs` for the component sampler,
`/docs/playground` to edit Slim and see it render, and `/status` for the
per-helper self-test.

`bin/puma` is a committed binstub, so it does not depend on gem executables
being on your PATH.

## Stack

Ruby ≥ 2.7.8 · Sinatra 4 · Rack 3 · Slim 5 · Stimulus 3 (supplied by consumer)

## Known gaps

- abide still owns seven controllers with no helper behind them. Some are
  domain behaviour and belong there; `crud-actions` and `auto-submit` look
  general enough to promote once something needs them twice.
- The docs playground (`POST /docs/render`) executes arbitrary Ruby. Local
  tool only; never deploy it.

## Done looks like

Zero inline `style=` in any consuming view, and no hand-written `data-*` for
framework behaviour. Checkable mechanically, in the rendered DOM as well as
the templates.

Both consumers reached this on 2026-07-29 — the demo from 113 inline styles,
abide from 64 — verified as 0 elements carrying a `style` attribute across
every page of both apps. The sole exception is the canvas Chart.js sizes
itself, which no template controls.

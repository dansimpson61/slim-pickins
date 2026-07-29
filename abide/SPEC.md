# Abide — Spec

A long-term aid for thinking about personal finances over time. Built to be
lived with, not shipped.

## Mission

Answer one question well: **given what I have and what I expect to happen,
where does this go?**

Second job: be the real workload that shapes slim-pickins. Every awkward
template here is a bug report against the DSL.

## Layering

Strict MVC, where the dependency direction is the whole point:

- **`lib/` — domain.** `Frequency`, `Flow`, `RecurringFlow`, and `Projection`
  know nothing of HTTP, Slim, or HTML, and are exercised by plain scripts.
  `Ledger` knows SQLite and nothing above it.
- **`app.rb` — routes.** Parse the request, call the domain, choose a view.
  No domain rules, no markup.
- **`views/` — slim-pickins vocabulary only.**

The domain does not know that presentation exists. That property, not the
folder names, is what is worth defending.

## Front end

abide expresses its front end **exclusively** in slim-pickins' lingo: no
inline styles, no raw HTML structure, and no hand-written `data-*` for
anything a helper emits. Where the DSL cannot yet say something, the DSL
grows — abide does not work around it.

Reached on 2026-07-29: **0** inline styles, down from 64, verified in the
rendered DOM. Cards, tables, icons, pills, modals, form fields, and
edit-in-place all come from helpers. Stimulus, SortableJS, and Chart.js are
vendored into `public/js/vendor`, so no CDN can take the app down.

Seven controllers remain abide's own. `withdrawal-form`, `valuation`,
`portfolio-manager`, `account-create`, and `river-chart` are domain behaviour
and belong here. `crud-actions` and `auto-submit` are general enough to
promote when something else needs them.

## Model

Everything is a **movement between two accounts**.

- **Account** — asset, liability, income, expense, or external. Three are
  structural: `Main Portfolio` (1), `External` (2), `Market` (3).
- **Movement** — an amount, a date, a source, a destination. Amounts are
  unsigned; sign is derived from whose side you ask about
  (`Flow#value_for(account_id)`).
- **Portfolio** — a named set of accounts. Balances aggregate, and movements
  *between* members net to zero.
- **Frequency** — a calendar rule: daily, weekly, monthly, quarterly, or
  yearly, with `on:`, `interval:`, `nth:`.
- **RecurringFlow** — a Frequency plus amount and endpoints. Expands into
  Movements across a date range.
- **Projection** — start balance plus expanded RecurringFlows, walked forward
  into a running timeline.

Market gains and losses are mark-to-market: state what an account is actually
worth, and abide records the difference as a movement.

## Surface

- `/` — dashboard and projection chart
- `/accounts` — CRUD, archive and restore
- `/portfolios`, `/portfolios/manage` — CRUD, membership
- `/movements` — CRUD
- `/accounts/:id/valuation` — mark to market
- `/api/projection` — timeline as JSON

## Running it

```
cd abide
bundle install
bin/puma -p 9393
```

Then <http://localhost:9393>. slim-pickins is a path dependency (`../slim-pickins`),
so both directories must be present; edits to the DSL take effect on restart.

`abide.db` is committed and already seeded. To start clean, delete it and run
`ruby db/setup_db.rb`.

## Storage

SQLite (`abide.db`). `db/setup_db.rb` creates and seeds the schema; it is
authoritative.

## Not this

Multi-user. Authentication. Live market data. Accounting-grade correctness or
tax advice. Anything that turns it into a product.

## Stack

Ruby · Sinatra 4 · Rack 3 · Slim 5 · SQLite · Stimulus 3

## Known gaps

- **RecurringFlows are not persisted.** Projections run off
  `sample_recurring_flows`, hardcoded in `app.rb` — domain data living in a
  route. This is both the main MVC violation and the main thing standing
  between abide and its stated purpose.
- `/accounts/:id/valuation` computes the delta and decides when a change is
  too small to record. Those are domain rules in a route.
- `db/migrations/*.sql` is a stale parallel schema and omits `movements`.
  Trust `setup_db.rb`.
- `public/css/style.css` still carries rules for the class vocabulary the
  views no longer use. Dead weight, safe to prune once the look is confirmed.

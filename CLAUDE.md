# CLAUDE.md

## Read first

The Ode to Joy tunes the hand for both projects. It lives in exactly one
place: `~/dev/ode-to-joy/ODE_TO_JOY.md`. ([`ODE_TO_JOY.md`](ODE_TO_JOY.md)
here is a pointer to it — the local copy was one of nine that had begun to
drift apart, and was retired on 2026-08-28.)

Then read the `SPEC.md` of whichever project you are about to change —
[`abide/SPEC.md`](abide/SPEC.md) or [`slim-pickins/SPEC.md`](slim-pickins/SPEC.md).

**Precedence** follows the Ode's Part II: correctness, then the house, then
clarity. This file and the specs are the house — they override the Ode where
they conflict. But say so when they do: name the divergence rather than
absorbing it, and let dan decide whether to align the project instead.

The rest is craft work for an audience of one: no users to break, no semver,
no deprecation cycle. Redesign freely, and prefer the change that makes the
code read better over the change that is merely smaller. Ugliness is a defect
even when it works.

## The two projects

- **`abide/`** — a personal-finance projection app. Sinatra, SQLite, port 9393.
  Also the real workload that shapes the DSL: every awkward template here is a
  bug report against slim-pickins.
- **`slim-pickins/`** — the front-end DSL abide is built in. A gem, consumed by
  path (`../slim-pickins`), with its own demo app on port 9292.

Both directories must be present. Edits to the DSL reach abide on restart.

## Rules that are easy to break by accident

1. **abide's views speak only slim-pickins.** No inline `style=`, no raw HTML
   structure, no hand-written `data-*` for anything a helper emits. When the
   DSL cannot say something, grow the DSL — never work around it in abide.
2. **Promotion is immediate; generalisation waits.** If a view needs it now, it
   becomes vocabulary now. But shape the first implementation around its one
   caller — the *second* caller is what earns a general API.
3. **Dependencies point one way**: views → helpers → domain. `abide/lib/` must
   not learn that HTTP, Slim, or HTML exist.
4. **Content is escaped by default.** Helpers return `SafeString`; a plain
   String is escaped on the way in. `+`, `join`, and interpolation drop the
   subclass, so a helper that composes strings re-marks the result itself.
5. **An affordance may not outlive its behaviour.** Scope grab cursors, grips,
   and hover lifts to the controller that answers them. Styling that lies is
   worse than styling that is missing.
6. **No build step. Ever.** Assets are served from the gem at `/assets`.
7. **The best JavaScript is the least JavaScript.** Slim, not ERB. Stimulus for
   behaviour, and only when markup and CSS genuinely cannot do it.

## Verifying

Verification here is by use, not by suite — these are apps with a human in the
loop, so a `/status` page catches what a test restating the implementation
would not. (The workspace rule this follows from is "Verification is
proportionate, not automatic"; tools others build on, like the dashboard, do
earn real tests.) Faults here are found by *using* the apps:

```
cd slim-pickins && bundle install && bin/puma -p 9292   # demo, /docs, /status
cd abide        && bundle install && bin/puma -p 9393
```

`/status` on the demo is the per-helper self-test. `/docs` is the component
sampler, `/docs/playground` renders arbitrary Slim — local only, never deploy
it. abide's domain has plain exercise scripts (`test_frequency_script.rb`,
`test_projection_script.rb`) runnable with bare `ruby`.

`abide.db` is committed and seeded. To start clean: delete it, then
`ruby db/setup_db.rb` — that script is the authoritative schema, not
`db/migrations/*.sql`, which is stale.

## Done looks like

Zero inline `style=` in any consuming view and no hand-written `data-*` for
framework behaviour — checked in the rendered DOM, not just the templates.
Both consumers reached that on 2026-07-29. Keep it there.

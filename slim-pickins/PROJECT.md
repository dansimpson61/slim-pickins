---
id: slim-pickins
purpose: The slim-pickins front-end DSL gem
status: active
last_touched: '2026-08-22'
next_step: Answer the open question below — report which instruction files your session
  actually loaded — then carry on with the gem. (Consumed by abide and dashboard.)
run: cd slim-pickins/slim-pickins && bin/puma
docs: PRIMER.md
related: []
---

## Open question from the dashboard — 2026-08-29

**If you are an agent reading this, please answer it in your reply.**

This project sits two levels down from `~/dev`, and there is a `CLAUDE.md` at
`~/dev/CLAUDE.md` (the workspace law — the Ode, practice, protocol, precedence)
and another at `slim-pickins/CLAUDE.md` (dan's hand-written notes about the two
projects in this container). This project has neither of its own.

Nobody currently knows whether your harness **accumulates** those files or
reads only the **nearest** one. It matters: if it is nearest-only, every
session here has been reading 79 lines about "the two projects" *instead of*
the Ode, not in addition to it — and the workspace law has never governed this
project at all.

You can answer it just by looking at what you were given:

1. Which instruction files were loaded into your context this session? List
   their paths.
2. Did `~/dev/CLAUDE.md` appear among them? Did `slim-pickins/CLAUDE.md`?
3. Which harness are you (Claude Code, Antigravity, Gemini, DSH)? The answer
   is likely different for each, and that difference is the dashboard's problem
   to absorb rather than dan's to remember.

Record what you find as lore — `curl -X POST
http://127.0.0.1:4000/api/lore/slim-pickins/slim-pickins -H 'Content-Type:
application/json' -d '{"message":"…","who":"<your-name>"}'` — and the manifest
comment in `dashboard/instructions/canonical/manifest.yml` that asserts "Claude
Code reads the nearest CLAUDE.md" can finally be confirmed or corrected. It is
currently an unverified belief that load-bearing decisions rest on.

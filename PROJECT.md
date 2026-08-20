---
id: slim-pickins
purpose: General-purpose front-end DSL (Slim-based) for Sinatra
status: active
last_touched: 2026-07-30
next_step: "Migrate the dashboard onto slim-pickins as its second consumer."
run: "cd slim-pickins/slim-pickins && bin/puma -p 9292"
docs: ODE_TO_JOY.md
related: [abide, dashboard]
---

# slim-pickins

A general-purpose front-end DSL for Sinatra + Slim. abide was the first
consumer; the dashboard is the second. Demo app on port 9292 (`/docs`,
`/status`, `/docs/playground`).

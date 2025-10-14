# The Slim-Pickins Philosophy

## Core Beliefs

### 1. Expression Over Specification

Templates should read like what you want to happen, not how to make it happen.

**Bad:**
```slim
div data-controller="modal" data-modal-open-value="false"
  button data-action="click->modal#open" Open
```

**Good:**
```slim
= modal id: "my-modal" do
  p Modal content
```

### 2. Hide the Ugly Parts

HTML and JavaScript are implementation details. Ruby is beautiful. Let Ruby express the intent, hide the ugly bits in helpers.

### 3. Maximize Tool Leverage

Use what exists. Slim has filters. Ruby has blocks. StimulusJS has conventions. Don't rebuild—recombine.

### 4. Convention, Lightly Applied

Just enough structure to create rhythm. Not so much that it becomes prison.

### 5. Progressive Enhancement

Start with working HTML. Add behavior where it brings joy.

### 6. No Build Complexity

The best build step is no build step. Ship files. Let browsers do their job.

## Anti-Patterns We Avoid

- ❌ Build tooling for simple sites
- ❌ JavaScript frameworks for server-rendered apps
- ❌ Clever abstractions that obscure intent
- ❌ Premature optimization
- ❌ Configuration over convention (when convention suffices)
- ❌ Dependencies that could be avoided

## Patterns We Embrace

- ✅ Server-side rendering by default
- ✅ Minimal JavaScript, maximal effect
- ✅ Helpers that compose naturally
- ✅ Blocks for content capture
- ✅ Data attributes for behavior
- ✅ Semantic HTML

## The Joy Metric

Before adding any feature, ask: **Does this bring joy?**

If it adds complexity without adding delight, reconsider.

## As Good As Bread

Simple ingredients:
- Ruby (the flour)
- Slim (the water)
- StimulusJS (the yeast)
- Modern CSS (the salt)

Mixed with care. Given time to rise. Baked with love.

The result: nourishing, satisfying, fundamental.

**This is Slim-Pickins.** 🍞

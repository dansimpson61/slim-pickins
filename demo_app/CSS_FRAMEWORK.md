# Using Slim-Pickins CSS Framework

## What's Included

The framework consists of three CSS files:

1. **slim-pickins-tokens.css** - Design tokens (colors, spacing, typography)
2. **slim-pickins-base.css** - Semantic HTML styling (no classes needed)
3. **slim-pickins-utils.css** - Utility classes for layout composition

The bundle file **slim-pickins.css** imports all three.

## Loading the Framework

### From Gem (Recommended)

```slim
/ In your layout
link rel="stylesheet" href="/slim-pickins/assets/stylesheets/slim-pickins.css"
```

Requires registering the AssetServer:

```ruby
class App < Sinatra::Base
  register SlimPickins
  register SlimPickins::AssetServer
end
```

### From CDN (Coming Soon)

```html
<link rel="stylesheet" href="https://unpkg.com/slim-pickins/dist/slim-pickins.css">
```

## Using Base Styles

Most HTML elements are beautifully styled by default:

```slim
h1 Heading 1
h2 Heading 2
p Body text with perfect line-height

table
  thead
    tr
      th Name
      th.numeric Value
  tbody
    tr
      td Item
      td.numeric $123.45
```

**Zero classes required!**

## Using Utility Classes

### Stack (Vertical Spacing)

```slim
.stack
  p First
  p Second
  p Third
```

### Cluster (Horizontal Spacing)

```slim
.cluster
  button One
  button Two
  button Three
```

### Typography Utilities

```slim
p.lead Large lead text
p.muted De-emphasized text
```

### Numeric Alignment

```slim
td.numeric Right-aligned number
```

## Design Tokens

Access tokens via CSS variables:

```css
color: var(--ink-900);        /* Primary text */
color: var(--ink-500);        /* Secondary text */
color: var(--accent-600);     /* Links, highlights */
background: var(--paper-0);   /* Page background */
border: var(--border-thin) solid var(--border-default);
padding: var(--sp-4);         /* 1rem spacing */
font-size: var(--fs-16);      /* 16px */
```

### Spacing Scale

```
--sp-1: 0.25rem (4px)
--sp-2: 0.5rem (8px)
--sp-3: 0.75rem (12px)
--sp-4: 1rem (16px)
--sp-5: 1.5rem (24px)
--sp-6: 2rem (32px)
--sp-7: 3rem (48px)
--sp-8: 4rem (64px)
```

### Font Sizes

```
--fs-12: 0.75rem
--fs-14: 0.875rem
--fs-16: 1rem (base)
--fs-18: 1.125rem
--fs-20: 1.25rem
--fs-24: 1.5rem

Fluid headings automatically scale:
--fs-fluid-h1: clamp(2rem, 5vw, 3rem)
```

## Dark Mode

Dark mode activates automatically based on system preference:

```css
@media (prefers-color-scheme: dark) {
  :root {
    --paper-0: #1a1a1a;
    --ink-900: #f5f5f5;
    /* All tokens adapt */
  }
}
```

## Print Styles

Documents print beautifully by default:

- High contrast colors
- Optimized margins
- Page break control
- Link URLs shown in print

## Philosophy

**Tufte's Data-Ink Ratio**: Every pixel should serve the content. Remove chartjunk. Let data speak.

**Semantic First**: HTML elements are styled beautifully by default. Add classes only for composition (stack, cluster) or emphasis (lead, muted).

**Progressive Enhancement**: Start with semantic HTML. Add utilities for layout. Reserve custom CSS for truly custom designs.

**Be as good as bread.** 🍞

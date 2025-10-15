#!/bin/bash
# Transform demo app to showcase slim-pickins CSS framework
set -e

echo "🎨 Transforming demo app to showcase slim-pickins.css framework..."
echo ""

# ============================================================================
# 1. Update app.rb to use AssetServer
# ============================================================================
cat > demo_app/app.rb << 'RUBY'
# frozen_string_literal: true

require 'sinatra/base'
require 'slim'
require 'json'

$LOAD_PATH.unshift File.expand_path('../../lib', __dir__)
require 'slim_pickins'
require 'slim_pickins/asset_server'

class DemoApp < Sinatra::Base
  register SlimPickins
  register SlimPickins::AssetServer  # Serve CSS from gem
  
  set :views, File.expand_path('views', __dir__)
  set :public_folder, File.expand_path('public', __dir__)
  
  configure :development do
    set :logging, true
  end
  
  # Calculation model
  class Calculation
    attr_accessor :principal, :rate, :years
    
    def initialize(principal: 10000, rate: 7.0, years: 10)
      @principal = principal.to_f
      @rate = rate.to_f
      @years = years.to_i
    end
    
    def final_amount
      principal * (1 + rate / 100) ** years
    end
    
    def interest
      final_amount - principal
    end
    
    def annual_growth
      interest / years
    end
    
    # Historical data for sparkline demo
    def year_by_year
      (0..years).map do |year|
        value = principal * (1 + rate / 100) ** year
        { year: year, amount: value }
      end
    end
    
    def to_h
      {
        principal: principal,
        rate: rate,
        years: years
      }
    end
  end
  
  # Home page with calculator
  get '/' do
    @calc = Calculation.new
    slim :index
  end
  
  # Reactive endpoint - receives JSON, returns HTML fragment
  post '/calculate' do
    content_type :html
    
    puts "📥 POST /calculate received"
    
    request.body.rewind
    body = request.body.read
    puts "📊 Request body: #{body}"
    
    data = JSON.parse(body)
    puts "✅ Parsed JSON: #{data.inspect}"
    
    @calc = Calculation.new(
      principal: data['principal'],
      rate: data['rate'],
      years: data['years']
    )
    
    puts "💰 Calculated:"
    puts "   Principal: $#{@calc.principal}"
    puts "   Rate: #{@calc.rate}%"
    puts "   Years: #{@calc.years}"
    puts "   Final: $#{'%.2f' % @calc.final_amount}"
    
    result = slim :_results, layout: false
    puts "📤 Sending HTML response (#{result.length} bytes)"
    result
  end
  
  # Examples page
  get '/examples' do
    @calc = Calculation.new(principal: 25000, rate: 8.5, years: 15)
    slim :examples
  end
end
RUBY

echo "✅ Updated demo_app/app.rb with AssetServer"

# ============================================================================
# 2. Update layout to use framework CSS
# ============================================================================
cat > demo_app/views/layout.slim << 'SLIM'
doctype html
html lang="en"
  head
    meta charset="utf-8"
    meta name="viewport" content="width=device-width, initial-scale=1"
    title Slim-Pickins Reactive Demo 🍞
    
    / Load slim-pickins CSS framework from gem
    link rel="stylesheet" href="/slim-pickins/assets/stylesheets/slim-pickins.css"
    
    / Stimulus for reactive forms
    script type="module" src="https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/dist/stimulus.min.js"
    script type="module" src="/js/app.js"
    
    / Minimal custom styles for demo-specific layout
    style
      | .demo-grid { display: grid; grid-template-columns: 1fr 1fr; gap: var(--sp-6); }
      | @media (max-width: 768px) { .demo-grid { grid-template-columns: 1fr; } }
  
  body.stack
    / Header using framework styles
    header style="border-bottom: var(--border-thin) solid var(--border-default); padding: var(--sp-5) 0;"
      .cluster style="max-width: 960px; margin: 0 auto; padding: 0 var(--sp-4);"
        h1 style="font-size: var(--fs-24); margin: 0;" 🍞 Slim-Pickins Reactive Demo
        nav.cluster style="gap: var(--sp-3);"
          a.muted href="/" Calculator
          a.muted href="/examples" Examples
    
    / Main content with max-width
    main.stack style="max-width: 960px; margin: 0 auto; padding: var(--sp-6) var(--sp-4);"
      == yield
    
    / Footer
    footer.muted style="text-align: center; padding: var(--sp-6) 0; border-top: var(--border-thin) solid var(--border-subtle);"
      p Be as good as bread. 🍞
SLIM

echo "✅ Updated demo_app/views/layout.slim with framework CSS"

# ============================================================================
# 3. Rewrite index.slim using semantic HTML + utilities
# ============================================================================
cat > demo_app/views/index.slim << 'SLIM'
/ Hero section - framework handles typography
article.stack
  h2 Compound Interest Calculator
  p.lead Watch it calculate as you type. No submit button needed.

/ Calculator form using framework base styles
section.stack
  == reactive_form model: @calc, target: "#results" do
    fieldset.cluster style="gap: var(--sp-4);"
      legend style="font-weight: var(--fw-medium); margin-bottom: var(--sp-3);" Investment Details
      == money_field :principal, value: @calc.principal
      == percent_field :rate, value: @calc.rate
      == year_field :years, value: @calc.years

/ Results container - framework provides table styling
#results.stack
  == slim :_results, layout: false

/ Explanation using semantic HTML
article.stack style="margin-top: var(--sp-7);"
  h3 How it works
  ol
    li Type in any field above
    li After 300ms, data is sent to server
    li Server calculates results in Ruby
    li Results automatically update below
    li No page reload, no explicit submit

/ Code example with framework pre styling
article.stack
  h3 The Template
  pre style="background: var(--paper-50); padding: var(--sp-4); border-radius: 4px; border: var(--border-thin) solid var(--border-default);"
    code
      | == reactive_form model: @calc, target: "#results" do
      |   == money_field :principal
      |   == percent_field :rate
      |   == year_field :years
      | 
      | #results
      |   / Results update here
  
  p.muted That's it. Clean, expressive, joyful. Framework handles the rest.
SLIM

echo "✅ Updated demo_app/views/index.slim with semantic HTML"

# ============================================================================
# 4. Update _results.slim to showcase data tables
# ============================================================================
cat > demo_app/views/_results.slim << 'SLIM'
/ Results using framework table styling
article.stack
  h3 Results
  
  / Data table - framework provides beautiful defaults
  table
    caption.sr-only Investment calculation results
    tbody
      tr
        td Final Amount
        td.numeric style="font-weight: var(--fw-semibold); color: var(--accent-600);"
          = "$%.2f" % @calc.final_amount
      tr
        td Interest Earned
        td.numeric = "$%.2f" % @calc.interest
      tr
        td Avg Annual Growth
        td.numeric = "$%.2f" % @calc.annual_growth
  
  / Small note using framework muted text
  p.muted style="margin-top: var(--sp-4); font-size: var(--fs-14);"
    | $#{"%.2f" % @calc.principal} invested at #{"%.1f" % @calc.rate}% 
    | for #{@calc.years} years
SLIM

echo "✅ Updated demo_app/views/_results.slim with framework table styling"

# ============================================================================
# 5. Create examples page showcasing CSS framework features
# ============================================================================
cat > demo_app/views/examples.slim << 'SLIM'
/ Examples page showcasing slim-pickins CSS framework

article.stack
  h2 Slim-Pickins CSS Framework
  p.lead A Tufte-inspired design system for data-forward web applications

/ Typography Example
section.stack style="padding: var(--sp-6); border: var(--border-thin) solid var(--border-default); border-radius: 4px;"
  h3 Typography Hierarchy
  
  h1 Heading 1 (Fluid Scale)
  h2 Heading 2 (Fluid Scale)
  h3 Heading 3 (Fluid Scale)
  h4 Heading 4
  
  p This is body text with proper line-height for readability. The framework provides semantic styling for all HTML elements with no classes required.
  
  p.lead This is lead text for emphasis.
  p.muted This is muted text for de-emphasis.
  
  p
    strong Bold text
    |  and 
    em italic text
    |  work naturally.

/ Data Table Example
section.stack style="padding: var(--sp-6); border: var(--border-thin) solid var(--border-default); border-radius: 4px;"
  h3 Data Tables
  p.muted Clean, readable tables following Tufte's principles
  
  table
    caption Investment Growth Projection
    thead
      tr
        th Year
        th.numeric Principal
        th.numeric Growth
        th.numeric Total
    tbody
      - (1..5).each do |year|
        - principal = @calc.principal
        - growth = principal * (@calc.rate / 100) * year
        - total = principal + growth
        tr
          td = year
          td.numeric = "$%.0f" % principal
          td.numeric = "$%.0f" % growth
          td.numeric style="font-weight: var(--fw-semibold);" = "$%.0f" % total

/ Layout Utilities Example
section.stack style="padding: var(--sp-6); border: var(--border-thin) solid var(--border-default); border-radius: 4px;"
  h3 Layout Utilities
  
  h4 Stack (Vertical Spacing)
  .stack
    p First paragraph in stack
    p Second paragraph in stack
    p Third paragraph in stack
  
  h4 Cluster (Horizontal Spacing)
  .cluster style="gap: var(--sp-3);"
    button Button 1
    button Button 2
    button Button 3
  
  h4 Grid (Two Column)
  .demo-grid
    article style="padding: var(--sp-4); background: var(--paper-50); border-radius: 4px;"
      h5 Column 1
      p Content in first column
    article style="padding: var(--sp-4); background: var(--paper-50); border-radius: 4px;"
      h5 Column 2
      p Content in second column

/ Forms Example
section.stack style="padding: var(--sp-6); border: var(--border-thin) solid var(--border-default); border-radius: 4px;"
  h3 Form Elements
  p.muted Beautiful forms with zero custom CSS
  
  form.stack
    fieldset.stack
      legend Investment Parameters
      
      label.stack
        span Principal Amount
        input type="number" value="25000" step="100"
      
      label.stack
        span Annual Return Rate
        input type="number" value="8.5" step="0.1"
      
      label.stack
        span Investment Period
        select
          option 5 years
          option 10 years
          option selected=true 15 years
          option 20 years
    
    button type="submit" Calculate

/ Color Tokens Example
section.stack style="padding: var(--sp-6); border: var(--border-thin) solid var(--border-default); border-radius: 4px;"
  h3 Design Tokens
  p.muted Semantic color system with dark mode support
  
  .cluster style="gap: var(--sp-4); flex-wrap: wrap;"
    .stack style="flex: 0 0 auto;"
      div style="width: 80px; height: 80px; background: var(--paper-0); border: var(--border-thin) solid var(--border-default); border-radius: 4px;"
      p.muted style="font-size: var(--fs-12); margin-top: var(--sp-2);" paper-0
    
    .stack style="flex: 0 0 auto;"
      div style="width: 80px; height: 80px; background: var(--ink-900); border-radius: 4px;"
      p.muted style="font-size: var(--fs-12); margin-top: var(--sp-2);" ink-900
    
    .stack style="flex: 0 0 auto;"
      div style="width: 80px; height: 80px; background: var(--accent-600); border-radius: 4px;"
      p.muted style="font-size: var(--fs-12); margin-top: var(--sp-2);" accent-600
    
    .stack style="flex: 0 0 auto;"
      div style="width: 80px; height: 80px; background: var(--border-default); border-radius: 4px;"
      p.muted style="font-size: var(--fs-12); margin-top: var(--sp-2);" border

/ Philosophy
article.stack style="margin-top: var(--sp-7); padding: var(--sp-6); background: var(--paper-50); border-radius: 4px;"
  h3 The Framework Philosophy
  
  ul
    li
      strong Expression over specification
      |  — Classes describe intent, not implementation
    li
      strong Tufte's data-ink ratio
      |  — Every pixel should serve the content
    li
      strong Semantic HTML first
      |  — Beautiful defaults for native elements
    li
      strong Progressive enhancement
      |  — Utilities for composition when needed
    li
      strong Print-friendly
      |  — Documents print beautifully by default
  
  p.muted style="margin-top: var(--sp-5);"
    | Be as good as bread. 🍞

/ Back link
nav style="margin-top: var(--sp-7);"
  a href="/" ← Back to Calculator
SLIM

echo "✅ Created demo_app/views/examples.slim showcasing framework"

# ============================================================================
# 6. Remove custom CSS file (no longer needed)
# ============================================================================
if [ -f "demo_app/public/css/demo.css" ]; then
  mv demo_app/public/css/demo.css demo_app/public/css/demo.css.backup
  echo "✅ Backed up custom CSS (no longer needed)"
fi

# ============================================================================
# 7. Create CSS framework documentation
# ============================================================================
cat > demo_app/CSS_FRAMEWORK.md << 'MD'
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
MD

echo "✅ Created CSS_FRAMEWORK.md documentation"

# ============================================================================
# Summary
# ============================================================================
echo ""
echo "════════════════════════════════════════"
echo "🎉 Demo app now showcases framework CSS!"
echo "════════════════════════════════════════"
echo ""
echo "What changed:"
echo "  1. ✅ AssetServer registered to serve CSS from gem"
echo "  2. ✅ Layout uses /slim-pickins/assets/stylesheets/slim-pickins.css"
echo "  3. ✅ All views rewritten with semantic HTML + utilities"
echo "  4. ✅ Custom CSS removed (backed up to demo.css.backup)"
echo "  5. ✅ Examples page showcases framework features"
echo "  6. ✅ CSS_FRAMEWORK.md documentation added"
echo ""
echo "Framework features showcased:"
echo "  • Typography hierarchy (h1-h6, p, lead, muted)"
echo "  • Data tables with numeric alignment"
echo "  • Form elements with beautiful defaults"
echo "  • Layout utilities (stack, cluster, grid)"
echo "  • Design tokens (spacing, colors, typography)"
echo "  • Dark mode support (automatic)"
echo "  • Print-friendly styling"
echo ""
echo "Start the demo:"
echo "  cd demo_app"
echo "  bundle exec rackup -p 9292"
echo ""
echo "Visit:"
echo "  → http://localhost:9292 (calculator)"
echo "  → http://localhost:9292/examples (framework showcase)"
echo ""
echo "The demo now exemplifies Tufte-inspired,"
echo "data-forward design with semantic HTML."
echo ""
echo "Be as good as bread. 🍞"

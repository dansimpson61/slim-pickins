# Beautiful Slim Templates: The Art of Expression

> **Templates that read like poetry, work like magic**

---

## The Philosophy

A Slim-Pickins template should:
1. **Read like a design specification** - You can understand it without Ruby knowledge
2. **Express intent, not implementation** - Say what you want, not how to build it
3. **Compose naturally** - Helpers nest like Russian dolls
4. **Format inline** - Data transforms where it's displayed
5. **Hide complexity** - No data attributes, no wiring, no ceremony

---

## Example 1: Dashboard (Current Capabilities)

### The Template
```slim
doctype html
html
  head
    title Analytics Dashboard
    link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css"
    script src="/js/app.js"
  
  body
    / Navigation bar
    nav.topbar
      .container
        .cluster.cluster-between
          h1.logo Analytics
          
          .cluster
            == nav_link "Dashboard", "/"
            == nav_link "Reports", "/reports"
            == nav_link "Settings", "/settings"
            
            == dropdown "Account" do
              == menu_item "Profile", "/profile"
              == menu_item "Logout", "/logout", method: :delete
    
    / Main content
    main.container
      .stack
        
        / Search and filter
        == card do
          .cluster.cluster-between
            == searchable "/search", placeholder: "Search metrics..."
            
            == simple_form "/filter", method: :get do
              .cluster
                == field :from, type: :date
                == field :to, type: :date
                == submit "Filter", class: "btn-secondary"
        
        / Key metrics
        .grid-3
          == card "Revenue" do
            .metric-value = number_to_currency(@metrics.revenue)
            .metric-change class=(@metrics.revenue_change > 0 ? "positive" : "negative")
              = "%.1f%%" % @metrics.revenue_change.abs
              = @metrics.revenue_change > 0 ? "↑" : "↓"
          
          == card "Orders" do
            .metric-value = number_with_delimiter(@metrics.orders)
            .metric-change class=(@metrics.order_change > 0 ? "positive" : "negative")
              = "%.1f%%" % @metrics.order_change.abs
              = @metrics.order_change > 0 ? "↑" : "↓"
          
          == card "Conversion" do
            .metric-value = "%.2f%%" % @metrics.conversion
            .metric-change class=(@metrics.conversion_change > 0 ? "positive" : "negative")
              = "%.1f%%" % @metrics.conversion_change.abs
              = @metrics.conversion_change > 0 ? "↑" : "↓"
        
        / Data tables
        .grid-2
          == card "Top Products" do
            table.data-table
              thead
                tr
                  th Product
                  th Revenue
                  th Change
              tbody
                - @top_products.each do |product|
                  tr
                    td = product.name
                    td.numeric = number_to_currency(product.revenue)
                    td.numeric class=(product.change > 0 ? "positive" : "negative")
                      = "%.1f%%" % product.change.abs
          
          == card "Recent Orders" do
            table.data-table
              thead
                tr
                  th ID
                  th Customer
                  th Total
                  th Date
              tbody
                - @recent_orders.each do |order|
                  tr
                    td
                      code = order.id
                    td = order.customer_name
                    td.numeric = number_to_currency(order.total)
                    td.muted = order.created_at.strftime("%b %d")
```

**What's Beautiful:**
- ✅ No data attributes visible
- ✅ Helpers create all interactive components
- ✅ Clean nesting and composition
- ✅ Utility classes for layout
- ✅ Ruby helpers for formatting (until filters arrive)

---

## Example 2: E-commerce Product Page

### The Template
```slim
doctype html
html
  head
    title = @product.name
    link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css"
    script src="/js/app.js"
  
  body
    main.container
      .stack
        
        / Breadcrumbs
        nav.breadcrumbs.muted
          a href="/" Home
          span.separator /
          a href="/products" Products
          span.separator /
          span.current = @product.name
        
        / Product detail
        .grid-2.gap-large
          
          / Image gallery
          .product-images
            == image @product.main_image, alt: @product.name, class: "main"
            
            .thumbnails.cluster
              - @product.images.each do |img|
                == image img, alt: @product.name, size: :thumb
          
          / Product info
          .product-info.stack
            h1 = @product.name
            
            .rating.cluster
              .stars
                - @product.rating.times do
                  span.star ★
                - (5 - @product.rating).times do
                  span.star.empty ☆
              .count.muted = "(#{@product.review_count} reviews)"
            
            / Price
            .price-section
              - if @product.on_sale?
                .price-group
                  .original.strike = number_to_currency(@product.original_price)
                  .sale.highlight = number_to_currency(@product.sale_price)
                  .savings.badge.success
                    = "Save #{number_to_currency(@product.savings)}"
              - else
                .current-price = number_to_currency(@product.price)
            
            / Variants
            - if @product.variants.any?
              == simple_form add_to_cart_path(@product) do
                == field :variant_id, 
                         type: :select, 
                         label: "Choose size",
                         options: @product.variants.map { |v| [v.name, v.id] }
                
                == field :quantity, 
                         type: :number, 
                         label: "Quantity",
                         value: 1,
                         min: 1,
                         max: @product.stock
                
                == submit "Add to Cart", class: "btn-primary btn-large"
            
            / Stock status
            .stock-status
              - if @product.in_stock?
                .badge.success ✓ In Stock
              - else
                .badge.danger Out of Stock
            
            / Description
            .description
              h3 Description
              = @product.description
        
        / Reviews
        == card "Customer Reviews" do
          .stack
            - @product.reviews.each do |review|
              .review
                .review-header.cluster.cluster-between
                  .reviewer
                    strong = review.author
                    .stars.muted
                      = "★" * review.rating
                      = "☆" * (5 - review.rating)
                  .date.muted = review.created_at.strftime("%b %d, %Y")
                
                .review-body
                  p = review.content
```

**What's Beautiful:**
- ✅ Semantic HTML structure
- ✅ Clear visual hierarchy
- ✅ Conditionals for business logic
- ✅ Helpers for forms and images
- ✅ Utility classes for layout

---

## Example 3: Financial Calculator (DSL Power)

### The Template
```slim
doctype html
html
  head
    title Compound Interest Calculator
    link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css"
    script src="/js/app.js"
  
  body
    main.container.center.prose
      
      h1 Compound Interest Calculator
      p.lead Calculate how your investment grows over time
      
      / Calculator form
      == calculator_form title: "Your Investment", 
                         model: @calc, 
                         target: "#results" do
        
        .form-grid
          == money_field :principal, 
                        value: @calc.principal,
                        label: "Initial Investment"
          
          == percent_field :rate,
                          value: @calc.rate,
                          label: "Annual Interest Rate"
          
          == year_field :years,
                       value: @calc.years,
                       label: "Time Period",
                       max: 50
      
      / Results (updates reactively)
      #results
        == card "Results" do
          
          / Build results hash
          - results = { \
              "Principal Amount": number_to_currency(@calc.principal), \
              "Interest Rate": "%.1f%%" % @calc.rate, \
              "Time Period": "#{@calc.years} years", \
              "Final Amount": number_to_currency(@calc.final_amount), \
              "Interest Earned": number_to_currency(@calc.interest), \
              "Effective Annual Rate": "%.2f%%" % @calc.effective_rate \
            }
          
          == results_table(results)
          
          / Growth visualization (placeholder)
          .growth-chart
            / Chart would render here via JavaScript
            #chart data-values=@calc.yearly_values.to_json
```

**What's Beautiful:**
- ✅ Domain-specific helpers (`money_field`, `percent_field`)
- ✅ Reactive form updates without page reload
- ✅ Clean data structure for results
- ✅ Minimal JavaScript needed

---

## Example 4: User Profile with Settings

### The Template
```slim
doctype html
html
  head
    title User Settings
    link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css"
    script src="/js/app.js"
  
  body
    main.container
      .stack
        
        h1 Account Settings
        
        / Tabs for different sections
        == tabs profile: "Profile", 
                security: "Security", 
                notifications: "Notifications",
                billing: "Billing" do
          
          .tab-panels
            
            / Profile tab
            .panel data-tab="profile"
              == card do
                .cluster.gap-large
                  
                  / Avatar section
                  .avatar-section
                    == avatar @user, size: :xlarge
                    == action_button "Change Photo", 
                                    action: "click->avatar#upload",
                                    class: "btn-secondary"
                  
                  / Profile form
                  .profile-form.grow
                    == simple_form user_path(@user), method: :patch do
                      == field :name, value: @user.name, required: true
                      == field :email, type: :email, value: @user.email, required: true
                      == field :phone, type: :tel, value: @user.phone
                      == field :bio, type: :textarea, value: @user.bio, rows: 4
                      == field :website, type: :url, value: @user.website
                      == submit "Save Changes", class: "btn-primary"
            
            / Security tab
            .panel data-tab="security"
              .stack
                
                == card "Change Password" do
                  == simple_form password_path, method: :patch do
                    == field :current_password, type: :password, required: true
                    == field :new_password, type: :password, required: true
                    == field :confirm_password, type: :password, required: true
                    == submit "Update Password", class: "btn-primary"
                
                == card "Two-Factor Authentication" do
                  - if @user.two_factor_enabled?
                    .cluster.cluster-between
                      .info
                        strong Two-factor authentication is enabled
                        p.muted Your account is protected with 2FA
                      == action_button "Disable", 
                                      action: "click->2fa#disable",
                                      class: "btn-danger"
                  - else
                    .cluster.cluster-between
                      .info
                        strong Two-factor authentication is disabled
                        p.muted Add an extra layer of security
                      == action_button "Enable", 
                                      action: "click->2fa#enable",
                                      class: "btn-primary"
                
                == card "Active Sessions" do
                  table.data-table
                    thead
                      tr
                        th Device
                        th Location
                        th Last Active
                        th
                    tbody
                      - @user.sessions.each do |session|
                        tr
                          td
                            strong = session.device
                            - if session.current?
                              .badge.primary Current
                          td.muted = session.location
                          td.muted = session.last_active.strftime("%b %d at %H:%M")
                          td
                            - unless session.current?
                              == action_button "Revoke",
                                              action: "click->session#revoke",
                                              data: { id: session.id },
                                              class: "btn-danger btn-small"
            
            / Notifications tab
            .panel data-tab="notifications"
              == card "Email Preferences" do
                == simple_form notifications_path, method: :patch do
                  
                  .form-section
                    h4 Marketing
                    == field :newsletter, 
                             type: :checkbox, 
                             label: "Weekly newsletter",
                             checked: @user.newsletter
                    == field :promotions,
                             type: :checkbox,
                             label: "Special offers and promotions",
                             checked: @user.promotions
                  
                  .form-section
                    h4 Activity
                    == field :comment_notifications,
                             type: :checkbox,
                             label: "Someone comments on my post",
                             checked: @user.comment_notifications
                    == field :mention_notifications,
                             type: :checkbox,
                             label: "Someone mentions me",
                             checked: @user.mention_notifications
                  
                  .form-section
                    h4 Digest
                    == field :digest_frequency,
                             type: :select,
                             label: "Email digest frequency",
                             options: [["Daily", "daily"], ["Weekly", "weekly"], ["Never", "never"]],
                             value: @user.digest_frequency
                  
                  == submit "Save Preferences", class: "btn-primary"
            
            / Billing tab
            .panel data-tab="billing"
              .stack
                
                == card "Current Plan" do
                  .cluster.cluster-between
                    .plan-info
                      h3 = @user.plan.name
                      p.muted = number_to_currency(@user.plan.price) + " / month"
                    == action_button "Upgrade", 
                                    action: "click->billing#upgrade",
                                    class: "btn-primary"
                
                == card "Payment Method" do
                  - if @user.payment_method
                    .cluster.cluster-between
                      .card-info
                        strong = @user.payment_method.brand
                        .muted
                          = "•••• •••• •••• #{@user.payment_method.last4}"
                          = "Expires #{@user.payment_method.exp_month}/#{@user.payment_method.exp_year}"
                      == action_button "Update", 
                                      action: "click->payment#update",
                                      class: "btn-secondary"
                  - else
                    p.muted No payment method on file
                    == action_button "Add Payment Method",
                                    action: "click->payment#add",
                                    class: "btn-primary"
                
                == card "Billing History" do
                  table.data-table
                    thead
                      tr
                        th Date
                        th Description
                        th Amount
                        th Status
                        th
                    tbody
                      - @user.invoices.each do |invoice|
                        tr
                          td.muted = invoice.date.strftime("%b %d, %Y")
                          td = invoice.description
                          td.numeric = number_to_currency(invoice.amount)
                          td
                            - if invoice.paid?
                              .badge.success Paid
                            - else
                              .badge.warning Pending
                          td
                            a.btn.btn-small href=invoice.pdf_url Download
```

**What's Beautiful:**
- ✅ Complex multi-section interface
- ✅ Tabs helper for organization
- ✅ Forms, tables, conditionals work together
- ✅ Action buttons with Stimulus wiring hidden
- ✅ Semantic structure throughout

---

## Example 5: Admin Dashboard (Data-Heavy)

### The Template
```slim
doctype html
html
  head
    title Admin Dashboard
    link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css"
    script src="/js/app.js"
  
  body
    .admin-layout
      
      / Sidebar
      aside.sidebar
        .sidebar-header
          h2 Admin
        
        nav.sidebar-nav
          == nav_link "Dashboard", admin_path
          == nav_link "Users", admin_users_path
          == nav_link "Products", admin_products_path
          == nav_link "Orders", admin_orders_path
          == nav_link "Reports", admin_reports_path
          == nav_link "Settings", admin_settings_path
      
      / Main content
      main.admin-main
        
        / Top bar
        header.admin-header
          .cluster.cluster-between
            h1 Dashboard
            
            .cluster
              == searchable "/admin/search", placeholder: "Search..."
              
              == dropdown "Admin" do
                == menu_item "Profile", admin_profile_path
                == menu_item "Logout", logout_path, method: :delete
        
        / Content
        .admin-content
          .stack
            
            / Stats grid
            .stats-grid
              == card do
                .stat
                  .stat-label Total Users
                  .stat-value = number_with_delimiter(@stats.total_users)
                  .stat-change.positive = "+#{@stats.user_growth}% this month"
              
              == card do
                .stat
                  .stat-label Revenue
                  .stat-value = number_to_currency(@stats.revenue)
                  .stat-change class=(@stats.revenue_change > 0 ? "positive" : "negative")
                    = "#{@stats.revenue_change > 0 ? '+' : ''}#{@stats.revenue_change}% vs last month"
              
              == card do
                .stat
                  .stat-label Orders
                  .stat-value = number_with_delimiter(@stats.orders)
                  .stat-change.positive = "+#{@stats.order_growth}% this week"
              
              == card do
                .stat
                  .stat-label Avg Order
                  .stat-value = number_to_currency(@stats.avg_order)
                  .stat-change.neutral = "#{@stats.avg_order_change}% change"
            
            / Recent activity
            == card "Recent Activity" do
              table.data-table
                tbody
                  - @recent_activity.each do |activity|
                    tr
                      td
                        strong = activity.user.name
                        = activity.action
                        strong = activity.target
                      td.muted.text-right = activity.created_at.strftime("%H:%M")
            
            / Grid of tables
            .grid-2
              == card "Top Products" do
                table.data-table
                  thead
                    tr
                      th Product
                      th Sales
                      th Revenue
                  tbody
                    - @top_products.each do |product|
                      tr
                        td = product.name
                        td.numeric = number_with_delimiter(product.sales)
                        td.numeric = number_to_currency(product.revenue)
              
              == card "Recent Orders" do
                table.data-table
                  thead
                    tr
                      th Order
                      th Customer
                      th Total
                      th Status
                  tbody
                    - @recent_orders.each do |order|
                      tr
                        td
                          code = "##{order.id}"
                        td = order.customer.name
                        td.numeric = number_to_currency(order.total)
                        td
                          - case order.status
                          - when 'pending'
                            .badge.warning Pending
                          - when 'processing'
                            .badge.info Processing
                          - when 'shipped'
                            .badge.primary Shipped
                          - when 'delivered'
                            .badge.success Delivered
                          - when 'cancelled'
                            .badge.danger Cancelled
```

**What's Beautiful:**
- ✅ Complex admin layout
- ✅ Sidebar navigation with active states
- ✅ Multiple data tables and stats
- ✅ Consistent helper usage throughout
- ✅ Clean conditional logic for badges

---

## The Common Patterns

### 1. **Structure with Helpers**
```slim
== card "Title" do
== modal id: "x" do
== tabs a: "A", b: "B" do
== simple_form path do
```

### 2. **Layout with Utilities**
```slim
.stack           / Vertical rhythm
.cluster         / Horizontal flow
.grid-2          / Two column grid
.center.prose    / Centered readable content
```

### 3. **Format with Ruby (until filters)**
```slim
= number_to_currency(@amount)
= number_with_delimiter(@count)
= date.strftime("%b %d, %Y")
= "%.1f%%" % @percentage
```

### 4. **Conditionals for Logic**
```slim
- if condition
  / Do this
- else
  / Do that
```

### 5. **Loops for Collections**
```slim
- @items.each do |item|
  == card item.name do
    / Item content
```

---

## The Joy of Clean Templates

**Before Slim-Pickins:**
```slim
div data-controller="modal" data-modal-open-value="false" class="modal-container"
  button data-action="click->modal#open" class="btn btn-primary" Open Modal
  div data-modal-target="backdrop" class="modal-backdrop hidden" data-action="click->modal#close"
    div data-modal-target="panel" class="modal-panel"
      button data-action="click->modal#close" class="modal-close" ×
      div class="modal-content"
        h2 My Modal
        p Modal content here
```

**With Slim-Pickins:**
```slim
== modal id: "example", trigger: "Open Modal" do
  h2 My Modal
  p Modal content here
```

**That's 9 lines → 3 lines. That's joy.** ✨

---

## Be as good as bread 🍞

**These templates are:**
- ✅ Readable by designers and developers
- ✅ Maintainable without deep framework knowledge
- ✅ Expressive of intent, not implementation
- ✅ Composed from simple, reusable helpers
- ✅ Structured with semantic HTML
- ✅ Styled with utility classes
- ✅ Interactive without exposed wiring

**This is what Slim-Pickins enables. This is the joy.** 🎉

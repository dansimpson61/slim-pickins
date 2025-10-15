# Examples

Real-world patterns and recipes.

## Complete CRUD Application

```ruby
# app.rb
require 'sinatra/base'
require 'slim-pickins'

class App < Sinatra::Base
  register SlimPickins
  
  get '/items' do
    @items = Item.all
    slim :index
  end
  
  post '/items' do
    Item.create(params[:item])
    redirect '/items'
  end
  
  get '/items/:id/edit' do
    @item = Item.find(params[:id])
    slim :edit
  end
  
  patch '/items/:id' do
    item = Item.find(params[:id])
    item.update(params[:item])
    redirect '/items'
  end
  
  delete '/items/:id' do
    Item.delete(params[:id])
    redirect '/items'
  end
end
```

```slim
/ views/index.slim
h1 Items

== modal id: "new-item", trigger: "New Item" do
  h2 Create Item
  == simple_form "/items" do
    == field :name, required: true
    == field :description, type: :textarea
    == submit "Create"

== searchable "/items/search"

.items
  - @items.each do |item|
    == card item.name do
      p = item.description
      .actions
        == action_button "Edit", action: "click->navigate#edit"
        form action="/items/#{item.id}" method="post" style="display: inline"
          input type="hidden" name="_method" value="delete"
          == submit "Delete", class: "btn-danger"
```

```slim
/ views/edit.slim
h1 Edit Item

== simple_form "/items/#{@item.id}", method: :patch do
  == field :name, value: @item.name, required: true
  == field :description, type: :textarea, value: @item.description
  == submit "Update"

== action_button "Cancel", action: "click->navigate#back"
```

## User Authentication

```slim
/ views/login.slim
== card "Login" do
  == simple_form "/login", method: :post do
    == field :email, type: :email, required: true
    == field :password, type: :password, required: true
    == submit "Sign In"
  
  p
    | Don't have an account? 
    a href="/signup" Sign up
```

## Dashboard with Stats

```slim
/ views/dashboard.slim
h1 Dashboard

.stats-grid
  == card "Users" do
    .stat-value = @user_count
    .stat-label Active users
  
  == card "Revenue" do
    .stat-value = number_to_currency(@revenue)
    .stat-label This month
  
  == card "Orders" do
    .stat-value = @order_count
    .stat-label Pending

== tabs overview: "Overview", activity: "Activity", settings: "Settings" do
  .tab-panels
    .panel data-tab="overview"
      h2 Overview
      / Overview content
    
    .panel data-tab="activity"
      h2 Recent Activity
      / Activity content
    
    .panel data-tab="settings"
      h2 Settings
      / Settings content
```

## Multi-step Form

```slim
/ views/signup.slim
== card "Create Account" do
  == simple_form "/signup", controller: "multistep" do
    .step data-step="1"
      h3 Personal Information
      == field :name, required: true
      == field :email, type: :email, required: true
      == action_button "Next", action: "click->multistep#next"
    
    .step.hidden data-step="2"
      h3 Account Details
      == field :username, required: true
      == field :password, type: :password, required: true
      .actions
        == action_button "Back", action: "click->multistep#previous"
        == submit "Create Account"
```

## Admin Panel

```slim
/ views/admin/layout.slim
doctype html
html
  head
    title Admin Panel
    link rel="stylesheet" href="/css/admin.css"
  body
    .admin-layout
      aside.sidebar
        nav
          == nav_link "Dashboard", "/admin"
          == nav_link "Users", "/admin/users"
          == nav_link "Posts", "/admin/posts"
          == nav_link "Settings", "/admin/settings"
      
      main.content
        header.topbar
          h1 Admin Panel
          == dropdown "Account" do
            == menu_item "Profile", "/admin/profile"
            == menu_item "Logout", "/logout", method: :delete
        
        == yield
```

## Real-time Search

```ruby
# app.rb
get '/search' do
  query = params[:q]
  @results = Product.search(query)
  slim :'partials/_results', layout: false
end
```

```slim
/ views/index.slim
== searchable "/search", placeholder: "Search products..."

#results
  / Results appear here dynamically
```

```slim
/ views/partials/_results.slim
- if @results.empty?
  p.empty No results found
- else
  .results
    - @results.each do |product|
      == card product.name do
        p.price = number_to_currency(product.price)
        == action_button "Add to Cart", action: "click->cart#add"
```

## Settings Page with Tabs

```slim
h1 Settings

== tabs profile: "Profile", security: "Security", notifications: "Notifications" do
  .tab-panels
    .panel data-tab="profile"
      == simple_form "/settings/profile", method: :patch do
        == field :name, value: @user.name
        == field :email, value: @user.email
        == field :bio, type: :textarea, value: @user.bio
        == submit "Save Profile"
    
    .panel data-tab="security"
      == simple_form "/settings/password", method: :patch do
        == field :current_password, type: :password, required: true
        == field :new_password, type: :password, required: true
        == field :confirm_password, type: :password, required: true
        == submit "Update Password"
    
    .panel data-tab="notifications"
      == simple_form "/settings/notifications", method: :patch do
        == field :email_notifications, type: :checkbox, label: "Email notifications"
        == field :sms_notifications, type: :checkbox, label: "SMS notifications"
        == submit "Save Preferences"
```

## Tips for Real Apps

1. **Extract partials** - Keep views DRY by extracting reusable components
2. **Use helpers** - Create custom helpers for domain-specific patterns
3. **Compose helpers** - Nest helpers naturally for complex UIs
4. **Keep it simple** - Don't fight the helpers, let them do the work
5. **Progressive enhancement** - Start with working HTML, add Stimulus as needed

**Be as good as bread.** 🍞

# Helpers Reference

Complete reference for all Slim-Pickins helpers.

## Component Helpers

### `card`

Create a styled card container.

**Signature:**
```ruby
card(title = nil, **opts, &block)
```

**Examples:**
```slim
/ Simple card
== card "My Title" do
  p Content

/ Card without title
== card do
  h3 Custom heading
  p Content

/ Card with Stimulus controller
== card "Interactive", controller: "animation" do
  p Animated content

/ Card with custom class
== card "Special", class: "featured" do
  p Featured content
```

**Options:**
- `title` - Card title (optional)
- `controller` - Stimulus controller name
- `class` - Additional CSS classes

---

### `action_button`

Create a button connected to a Stimulus action.

**Signature:**
```ruby
action_button(label, action:, **opts)
```

**Examples:**
```slim
== action_button "Click Me", action: "click->demo#handleClick"
== action_button "Delete", action: "click->item#delete", class: "btn-danger"
```

**Options:**
- `label` - Button text (required)
- `action` - Stimulus action (required)
- `class` - CSS class (default: "btn")

---

### `nav_link`

Create a navigation link that automatically highlights when active.

**Signature:**
```ruby
nav_link(text, path, **opts)
```

**Examples:**
```slim
== nav_link "Home", "/"
== nav_link "About", "/about"
== nav_link "Contact", "/contact", class: "special"
```

**Options:**
- `text` - Link text (required)
- `path` - Link href (required)
- `class` - Additional CSS classes

**Note:** Automatically adds "active" class when `request.path` matches path.

---

### `icon`

Render an SVG icon.

**Signature:**
```ruby
icon(name, **opts)
```

**Examples:**
```slim
== icon :edit
== icon :trash, size: 32
== icon :check, class: "text-success"
```

**Options:**
- `name` - Icon name (required)
- `size` - Icon size in pixels (default: 24)
- `class` - Additional CSS classes

**Note:** Uses SVG sprite pattern. Define sprites in your layout.

---

## Pattern Helpers

### `modal`

Create a modal dialog.

**Signature:**
```ruby
modal(id:, trigger: nil, **opts, &block)
```

**Examples:**
```slim
/ Basic modal
== modal id: "example", trigger: "Open Modal" do
  h2 Modal Title
  p Modal content

/ Custom trigger text
== modal id: "confirm", trigger: "Delete Item" do
  p Are you sure?
  == action_button "Confirm", action: "click->item#delete"
```

**Options:**
- `id` - Modal identifier (required)
- `trigger` - Trigger button text (default: "Open")

**Features:**
- Closes on ESC key
- Closes on backdrop click
- Auto-focuses on open

---

### `dropdown`

Create a dropdown menu.

**Signature:**
```ruby
dropdown(label, **opts, &block)
```

**Examples:**
```slim
== dropdown "Actions" do
  == menu_item "Edit", edit_path(item)
  == menu_item "Delete", item_path(item), method: :delete

== dropdown "User Menu" do
  == menu_item "Profile", "/profile"
  == menu_item "Settings", "/settings"
  == menu_item "Logout", "/logout", method: :delete
```

**Options:**
- `label` - Dropdown button text (required)

---

### `menu_item`

Create a menu item for dropdowns.

**Signature:**
```ruby
menu_item(text, path, **opts)
```

**Examples:**
```slim
== menu_item "Profile", "/profile"
== menu_item "Delete", "/items/1", method: :delete
```

**Options:**
- `text` - Link text (required)
- `path` - Link href (required)
- `method` - HTTP method for the link

---

### `searchable`

Create a live search input.

**Signature:**
```ruby
searchable(path, placeholder: "Search...", **opts)
```

**Examples:**
```slim
== searchable "/search"
== searchable "/items/search", placeholder: "Find items..."
```

**Options:**
- `path` - Search endpoint URL (required)
- `placeholder` - Input placeholder text

**Server Response:**
Your search endpoint should return an HTML fragment to replace results.

---

### `sortable_list`

Create a sortable list with drag-and-drop.

**Signature:**
```ruby
sortable_list(items, url:, &block)
```

**Examples:**
```slim
== sortable_list @items, url: reorder_items_path do |item|
  = item.name
```

**Options:**
- `items` - Collection to iterate (required)
- `url` - Reorder endpoint (required)

**Note:** Items must respond to `.id`

---

### `tabs`

Create a tabbed interface.

**Signature:**
```ruby
tabs(**tab_hash, &block)
```

**Examples:**
```slim
== tabs home: "Home", about: "About", contact: "Contact" do
  .tab-panels
    .panel data-tab="home"
      h3 Home Content
    .panel data-tab="about"
      h3 About Content
    .panel data-tab="contact"
      h3 Contact Content
```

**Options:**
- Tab keys become data-tab values
- Tab values become button labels

---

## Form Helpers

### `simple_form`

Create a form with automatic method handling.

**Signature:**
```ruby
simple_form(action, method: :post, **opts, &block)
```

**Examples:**
```slim
/ POST form
== simple_form "/items" do
  == field :name
  == submit

/ PATCH form (generates hidden _method field)
== simple_form "/items/1", method: :patch do
  == field :name
  == submit "Update"

/ Custom controller
== simple_form "/search", method: :get, controller: "search" do
  == field :query
  == submit "Search"
```

**Options:**
- `action` - Form action URL (required)
- `method` - HTTP method (default: :post)
- `controller` - Stimulus controller (default: "form")

**Note:** Automatically adds hidden `_method` field for PUT, PATCH, DELETE.

---

### `field`

Create a form field with label.

**Signature:**
```ruby
field(name, type: :text, label: nil, **opts)
```

**Examples:**
```slim
/ Text input
== field :name

/ With custom label
== field :email, label: "Email Address"

/ Required field
== field :password, type: :password, required: true

/ Textarea
== field :bio, type: :textarea

/ Select dropdown
== field :role, type: :select, options: ["Admin", "User", "Guest"]

/ With value
== field :name, value: @user.name
```

**Types:**
- `:text` (default)
- `:email`
- `:password`
- `:textarea`
- `:select`
- Any HTML5 input type

**Options:**
- `name` - Field name (required)
- `type` - Field type (default: :text)
- `label` - Custom label text
- `required` - Mark as required
- `value` - Default value
- `options` - Array of options (for select)

---

### `submit`

Create a submit button.

**Signature:**
```ruby
submit(text = "Submit", **opts)
```

**Examples:**
```slim
== submit
== submit "Create Item"
== submit "Delete", class: "btn-danger"
```

**Options:**
- `text` - Button text (default: "Submit")
- `class` - CSS class (default: "btn btn-primary")

---

## Stimulus Helpers

Low-level helpers for custom Stimulus integration.

### `stimulus_attrs`

Generate Stimulus controller and value attributes.

**Signature:**
```ruby
stimulus_attrs(controller, **values)
```

**Examples:**
```ruby
stimulus_attrs("modal")
# => data-controller="modal"

stimulus_attrs("modal", open: false, duration: 300)
# => data-controller="modal" data-modal-open-value="false" data-modal-duration-value="300"
```

---

### `action_attr`

Generate a Stimulus action attribute.

**Signature:**
```ruby
action_attr(action)
```

**Examples:**
```ruby
action_attr("click->modal#open")
# => data-action="click->modal#open"
```

---

### `target_attr`

Generate a Stimulus target attribute.

**Signature:**
```ruby
target_attr(controller, target)
```

**Examples:**
```ruby
target_attr("modal", "backdrop")
# => data-modal-target="backdrop"
```

---

## Helper Composition

Helpers compose naturally:

```slim
== modal id: "new-item", trigger: "Create" do
  h2 New Item
  == simple_form "/items" do
    == field :title, required: true
    == field :description, type: :textarea
    == submit "Create Item"
```

Helpers can be nested and combined freely. The output is always clean HTML with proper Stimulus attributes.

## Creating Custom Helpers

Add your own helpers in `helpers/` directory:

```ruby
# helpers/custom_helpers.rb
module CustomHelpers
  def badge(text, color: :blue)
    "<span class=\"badge badge-#{color}\">#{text}</span>"
  end
end

# Then include in your app
class App < Sinatra::Base
  helpers CustomHelpers
end
```

**Remember:** Return HTML strings, and users should call with `==` in templates.

---

**As good as bread.** 🍞

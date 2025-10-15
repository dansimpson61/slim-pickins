# frozen_string_literal: true

# Simple in-memory Todo model
class Todo
  attr_reader :id, :title, :description, :completed, :created_at
  
  @@todos = []
  @@next_id = 1
  
  def initialize(id:, title:, description: nil, completed: false, created_at: Time.now)
    @id = id
    @title = title
    @description = description
    @completed = completed
    @created_at = created_at
  end
  
  def self.create(title:, description: nil)
    todo = new(
      id: @@next_id,
      title: title,
      description: description
    )
    @@next_id += 1
    @@todos << todo
    todo
  end
  
  def self.all
    @@todos.sort_by { |t| [t.completed ? 1 : 0, -t.id] }
  end
  
  def self.active
    @@todos.reject(&:completed)
  end
  
  def self.find(id)
    @@todos.find { |t| t.id == id }
  end
  
  def self.delete(id)
    @@todos.reject! { |t| t.id == id }
  end
  
  def self.search(query)
    return all if query.nil? || query.empty?
    
    @@todos.select do |todo|
      todo.title.downcase.include?(query.downcase) ||
      (todo.description && todo.description.downcase.include?(query.downcase))
    end
  end
  
  def toggle_complete!
    @completed = !@completed
  end
  
  def completed?
    @completed
  end
end

# Seed some data
Todo.create(title: "Try Slim-Pickins", description: "Build something joyful")
Todo.create(title: "Read the philosophy", description: "Understand expression over specification")
Todo.create(title: "Write clean templates", description: "Hide the ugly parts")

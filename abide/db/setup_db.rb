require 'sqlite3'

db = SQLite3::Database.new("abide.db")

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS portfolio (
    id INTEGER PRIMARY KEY,
    name TEXT,
    balance REAL,
    growth_rate REAL
  );
SQL

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS movements (
    id INTEGER PRIMARY KEY,
    description TEXT,
    amount REAL,
    date TEXT,
    frequency TEXT, -- 'one_time', 'monthly', 'yearly'
    is_taxable INTEGER DEFAULT 0,
    federal_tax_rate REAL DEFAULT 0.0,
    state_tax_rate REAL DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

# Seed initial data if empty
count = db.get_first_value("SELECT COUNT(*) FROM portfolio")
if count == 0
  db.execute("INSERT INTO portfolio (name, balance, growth_rate) VALUES (?, ?, ?)", ["Main Portfolio", 1450000.0, 0.07])
  
  # Seed sample movements
  db.execute("INSERT INTO movements (description, amount, date, frequency, is_taxable) VALUES (?, ?, ?, ?, ?)", 
             ["Initial Savings", 5000.0, "2024-01-15", "one_time", 0])
  db.execute("INSERT INTO movements (description, amount, date, frequency, is_taxable) VALUES (?, ?, ?, ?, ?)", 
             ["Living Expenses", -7500.0, "2024-10-15", "monthly", 0])
end

puts "Database seeded."

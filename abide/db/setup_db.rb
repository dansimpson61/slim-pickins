require 'sqlite3'

db = SQLite3::Database.new("abide.db")
db.results_as_hash = true

# 1. Accounts Table
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- 'asset', 'liability', 'income', 'expense', 'external'
    is_active INTEGER DEFAULT 1
  );
SQL

# 2. Movements (Flows) Table
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS movements (
    id INTEGER PRIMARY KEY,
    description TEXT,
    amount REAL,
    date TEXT,
    is_taxable INTEGER DEFAULT 0,
    federal_tax_rate REAL DEFAULT 0.0,
    state_tax_rate REAL DEFAULT 0.0,
    source_account_id INTEGER,
    destination_account_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

# 3. Portfolios Tables
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS portfolios (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
  );
SQL

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS portfolio_accounts (
    portfolio_id INTEGER,
    account_id INTEGER,
    PRIMARY KEY (portfolio_id, account_id),
    FOREIGN KEY(portfolio_id) REFERENCES portfolios(id),
    FOREIGN KEY(account_id) REFERENCES accounts(id)
  );
SQL

# Seed initial data if empty
count = db.get_first_value("SELECT COUNT(*) FROM accounts")
if count == 0
  puts "Seeding default accounts..."
  db.execute("INSERT INTO accounts (id, name, type) VALUES (?, ?, ?)", [1, "Main Portfolio", "asset"])
  db.execute("INSERT INTO accounts (id, name, type) VALUES (?, ?, ?)", [2, "External", "external"])
  db.execute("INSERT INTO accounts (id, name, type) VALUES (?, ?, ?)", [3, "Market", "external"])
  
  puts "Seeding sample flows..."
  # Initial Savings: External -> Main
  db.execute(
    "INSERT INTO movements (description, amount, date, source_account_id, destination_account_id, is_taxable) VALUES (?, ?, ?, ?, ?, ?)", 
    ["Initial Savings", 5000.0, "2024-01-15", 2, 1, 0]
  )
  
  # Living Expenses: Main -> External
  db.execute(
    "INSERT INTO movements (description, amount, date, source_account_id, destination_account_id, is_taxable) VALUES (?, ?, ?, ?, ?, ?)", 
    ["Living Expenses", 7500.0, "2024-10-15", 1, 2, 0]
  )
end

puts "Database ready (Clean Schema)."

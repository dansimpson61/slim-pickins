require 'sqlite3'
require 'date'
require_relative 'flow'

class Ledger
  def initialize(db_path = "abide.db")
    @db = SQLite3::Database.new(db_path)
    @db.results_as_hash = true
  end

  # Calculate balance for a specific account
  def balance(account_id = 1) # Default to Main Portfolio (1)
    # Sum inflows (where dest = id)
    inflows = @db.get_first_value("SELECT SUM(amount) FROM movements WHERE destination_account_id = ?", [account_id]) || 0.0
    
    # Sum outflows (where source = id)
    outflows = @db.get_first_value("SELECT SUM(amount) FROM movements WHERE source_account_id = ?", [account_id]) || 0.0
    
    inflows - outflows
  end

  # Calculate balance for a portfolio (collection of accounts)
  def portfolio_balance(portfolio_id)
    # Get all accounts in this portfolio
    account_ids = @db.execute("SELECT account_id FROM portfolio_accounts WHERE portfolio_id = ?", [portfolio_id]).map { |row| row['account_id'] }
    
    # Sum the balance of each account
    account_ids.sum { |id| balance(id) }
  end

  def create_portfolio(name)
    @db.execute("INSERT INTO portfolios (name) VALUES (?)", [name])
    @db.last_insert_row_id
  end

  def add_account_to_portfolio(portfolio_id, account_id)
    @db.execute("INSERT OR IGNORE INTO portfolio_accounts (portfolio_id, account_id) VALUES (?, ?)", [portfolio_id, account_id])
  end
  
  def get_portfolios
    @db.execute("SELECT * FROM portfolios")
  end

  def delete_portfolio(id)
    @db.execute("DELETE FROM portfolio_accounts WHERE portfolio_id = ?", [id])
    @db.execute("DELETE FROM portfolios WHERE id = ?", [id])
  end

  def get_portfolio_accounts(portfolio_id)
    @db.execute(
      "SELECT a.* FROM accounts a JOIN portfolio_accounts pa ON a.id = pa.account_id WHERE pa.portfolio_id = ?", 
      [portfolio_id]
    )
  end

  def get_accounts(include_archived: false)
    if include_archived
      @db.execute("SELECT * FROM accounts")
    else
      @db.execute("SELECT * FROM accounts WHERE is_active = 1")
    end
  end

  def create_account(name, type)
    @db.execute("INSERT INTO accounts (name, type, is_active) VALUES (?, ?, 1)", [name, type])
    @db.last_insert_row_id
  end

  def update_account(id, name, type)
    @db.execute("UPDATE accounts SET name = ?, type = ? WHERE id = ?", [name, type, id])
  end

  def archive_account(id)
    @db.execute("UPDATE accounts SET is_active = 0 WHERE id = ?", [id])
  end

  def restore_account(id)
    @db.execute("UPDATE accounts SET is_active = 1 WHERE id = ?", [id])
  end

  def delete_account(id)
    # Only delete if no flows exist
    count = @db.get_first_value("SELECT COUNT(*) FROM movements WHERE source_account_id = ? OR destination_account_id = ?", [id, id])
    if count > 0
      raise "Cannot delete account with existing records. Archive it instead."
    end
    @db.execute("DELETE FROM accounts WHERE id = ?", [id])
  end

  def add(flow)
    tax = flow.tax_info || {}
    @db.execute(
      "INSERT INTO movements (description, amount, date, is_taxable, federal_tax_rate, state_tax_rate, source_account_id, destination_account_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
      [
        flow.description,
        flow.amount,
        flow.date.to_s,
        tax[:is_taxable] ? 1 : 0,
        tax[:federal_tax_rate] || 0.0,
        tax[:state_tax_rate] || 0.0,
        flow.source_id,
        flow.destination_id
      ]
    )
  end

  def delete(id)
    @db.execute("DELETE FROM movements WHERE id = ?", [id])
  end

  def update(id, flow)
    tax = flow.tax_info || {}
    @db.execute(
      "UPDATE movements SET description = ?, amount = ?, date = ?, is_taxable = ?, federal_tax_rate = ?, state_tax_rate = ?, source_account_id = ?, destination_account_id = ? WHERE id = ?",
      [
        flow.description,
        flow.amount,
        flow.date.to_s,
        tax[:is_taxable] ? 1 : 0,
        tax[:federal_tax_rate] || 0.0,
        tax[:state_tax_rate] || 0.0,
        flow.source_id,
        flow.destination_id,
        id
      ]
    )
  end

  # Get recent flows, optionally filtered by account
  def recent(limit = 10, account_id = nil)
    query = "SELECT * FROM movements"
    params = []
    
    if account_id
      query += " WHERE source_account_id = ? OR destination_account_id = ?"
      params << account_id << account_id
    end
    
    query += " ORDER BY date DESC LIMIT ?"
    params << limit

    rows = @db.execute(query, params)
    rows.map do |row|
      Flow.new(
        id: row['id'],
        amount: row['amount'].to_f,
        date: Date.parse(row['date']),
        description: row['description'],
        source_id: row['source_account_id'],
        destination_id: row['destination_account_id'],
        tax_info: {
          is_taxable: row['is_taxable'] == 1,
          federal_tax_rate: row['federal_tax_rate'],
          state_tax_rate: row['state_tax_rate']
        }
      )
    end
  end
end

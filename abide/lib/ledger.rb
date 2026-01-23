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

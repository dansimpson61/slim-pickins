require 'sqlite3'
require 'date'
require_relative 'movement'

class Ledger
  def initialize(db_path = "abide.db")
    @db = SQLite3::Database.new(db_path)
    @db.results_as_hash = true
  end

  def balance
    # Sum of all movements
    result = @db.get_first_value("SELECT SUM(amount) FROM movements")
    result || 0.0
  end

  def add(movement)
    tax = movement.tax_info || {}
    @db.execute(
      "INSERT INTO movements (description, amount, date, frequency, is_taxable, federal_tax_rate, state_tax_rate) VALUES (?, ?, ?, ?, ?, ?, ?)",
      [
        movement.description,
        movement.amount,
        movement.date.to_s,
        'one_time', # Historical facts are effectively one-time events
        tax[:is_taxable] ? 1 : 0,
        tax[:federal_tax_rate] || 0.0,
        tax[:state_tax_rate] || 0.0
      ]
    )
  end

  def delete(id)
    @db.execute("DELETE FROM movements WHERE id = ?", [id])
  end

  def update(id, movement)
    tax = movement.tax_info || {}
    @db.execute(
      "UPDATE movements SET description = ?, amount = ?, date = ?, is_taxable = ?, federal_tax_rate = ?, state_tax_rate = ? WHERE id = ?",
      [
        movement.description,
        movement.amount,
        movement.date.to_s,
        tax[:is_taxable] ? 1 : 0,
        tax[:federal_tax_rate] || 0.0,
        tax[:state_tax_rate] || 0.0,
        id
      ]
    )
  end

  def recent(limit = 10)
    rows = @db.execute("SELECT * FROM movements ORDER BY date DESC LIMIT ?", [limit])
    rows.map do |row|
      Movement.new(
        id: row['id'],
        amount: row['amount'].to_f,
        date: Date.parse(row['date']),
        description: row['description'],
        tax_info: {
          is_taxable: row['is_taxable'] == 1,
          federal_tax_rate: row['federal_tax_rate'],
          state_tax_rate: row['state_tax_rate']
        }
      )
    end
  end
  
  # For projection purposes, we might want 'balance_at(date)' but 
  # usually we just take current balance and project forward.
end

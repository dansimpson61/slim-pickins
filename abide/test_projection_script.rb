require_relative 'lib/frequency'
require_relative 'lib/movement'
require_relative 'lib/recurring_movement'
require_relative 'lib/projection'
require_relative 'lib/ledger'
require 'date'

# 0. Setup Mock Ledger (to avoid messing with real DB, or just use real one if safe? Better to mock for pure logic test)
# We'll use a stub for the Ledger in this script to keep it self-contained
class MockLedger
  attr_accessor :balance
  def initialize(balance:)
    @balance = balance
  end
end

puts "--- Verifying Temporal Movements Logic ---"

# 1. Setup
start_date = Date.parse("2024-01-01")
ledger = MockLedger.new(balance: 1000.0)

# 2. Define Rules
# Rule A: Rent, -$500, Monthly on the 1st
rent = RecurringMovement.new(
  frequency: Frequency.monthly(on: 1),
  base_amount: -500.0,
  description: "Rent",
  start_date: Date.parse("2023-01-01") # Started last year, still active
)

# Rule B: One-Off Roof Repair, -$200, on Feb 15th
repair = RecurringMovement.new(
  frequency: Frequency.once(on: Date.parse("2024-02-15")),
  base_amount: -200.0,
  description: "Roof Repair",
  start_date: Date.parse("2024-01-01")
)

# Rule C: Gym Membership, -$50, Monthly on 5th, ENDS in March 2024
gym = RecurringMovement.new(
  frequency: Frequency.monthly(on: 5),
  base_amount: -50.0,
  description: "Gym",
  start_date: Date.parse("2024-01-01"),
  end_date: Date.parse("2024-03-01") # Should run Jan, Feb, but stop before Mar 5? Let's see window logic.
)

rules = [rent, repair, gym]

# 3. Build Projection
projection = Projection.new(ledger: ledger, recurring_movements: rules, start_date: start_date)
timeline = projection.build(period_in_months: 3) # Jan, Feb, Mar

# 4. Print & specific assertions
puts "\nStarting Balance: $#{ledger.balance}"
puts "Projecting from #{start_date} for 3 months..."

timeline.each do |entry|
  puts "#{entry[:date]} | #{entry[:description].ljust(15)} | #{entry[:amount].to_s.rjust(8)} | Bal: #{entry[:balance]}"
end

# Sanity Checks
passed = true

# Check Rent - should be Jan 1, Feb 1, Mar 1
rent_count = timeline.count { |e| e[:description] == "Rent" }
if rent_count == 3
  puts "[PASS] Rent appears 3 times"
else
  puts "[FAIL] Rent appears #{rent_count} times (Expected 3)"
  passed = false
end

# Check Repair - should be Feb 15 only
repair_dates = timeline.select { |e| e[:description] == "Roof Repair" }.map { |e| e[:date].to_s }
if repair_dates == ["2024-02-15"]
  puts "[PASS] Roof Repair is exactly on 2024-02-15"
else
  puts "[FAIL] Roof Repair dates: #{repair_dates}"
  passed = false
end

# Check Gym - Ends March 1st. 
# Occurrences: Jan 5, Feb 5. Mar 5 is > End Date.
gym_count = timeline.count { |e| e[:description] == "Gym" }
if gym_count == 2
  puts "[PASS] Gym appears 2 times (Jan, Feb) correctly respecting end_date"
else
  puts "[FAIL] Gym appears #{gym_count} times (Expected 2)"
  passed = false
end

if passed
  puts "\nALL VERIFICATIONS PASSED"
else
  puts "\nSOME VERIFICATIONS FAILED"
end

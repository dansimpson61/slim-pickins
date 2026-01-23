require_relative 'lib/frequency'
require 'date'

def assert_match(frequency, date_str, expected)
  date = Date.parse(date_str)
  result = frequency.include?(date)
  status = result == expected ? "PASS" : "FAIL"
  puts "[#{status}] #{date_str} should be #{expected} -> #{result}"
  puts "   Frequency: period=#{frequency.period}, on=#{frequency.on}, nth=#{frequency.nth}" unless result == expected
end

puts "--- 1. Monthly on the 3rd ---"
f1 = Frequency.monthly(on: 3)
assert_match(f1, '2023-01-03', true)
assert_match(f1, '2023-02-03', true)
assert_match(f1, '2023-01-04', false)
puts "Next after 2023-01-05: #{f1.next_occurrence(after: Date.parse('2023-01-05'))} (Expected 2023-02-03)"

puts "\n--- 2. Monthly on the second Wednesday ---"
f2 = Frequency.monthly(on: :wednesday, nth: 2)
# Jan 2023: 1st(Sun), 4th(Wed-1), 11th(Wed-2)
assert_match(f2, '2023-01-11', true)
assert_match(f2, '2023-01-04', false)
puts "Next after 2023-01-01: #{f2.next_occurrence(after: Date.parse('2023-01-01'))} (Expected 2023-01-11)"

puts "\n--- 3. Weekly on Tuesday ---"
f3 = Frequency.weekly(on: :tuesday)
# Jan 2023: 3rd is Tuesday
assert_match(f3, '2023-01-03', true)
assert_match(f3, '2023-01-10', true)
assert_match(f3, '2023-01-04', false)

puts "\n--- 4. 2 times/month on the 5th and 20th ---"
f4 = Frequency.monthly(on: [5, 20])
assert_match(f4, '2023-01-05', true)
assert_match(f4, '2023-01-20', true)
assert_match(f4, '2023-01-06', false)
puts "Next after 2023-01-06: #{f4.next_occurrence(after: Date.parse('2023-01-06'))} (Expected 2023-01-20)"

puts "\n--- 5. Quarterly on the 1st of Jan, April, July, Oct ---"
f5 = Frequency.quarterly(on: 1) 
# checks default months
assert_match(f5, '2023-01-01', true)
assert_match(f5, '2023-04-01', true)
assert_match(f5, '2023-02-01', false)
puts "Next after 2023-01-01: #{f5.next_occurrence(after: Date.parse('2023-01-01'))} (Expected 2023-04-01)"

puts "\n--- 6. Twice per year on the 3rd of January and July ---"
f6 = Frequency.yearly(on: 3, months: [:jan, :jul])
assert_match(f6, '2023-01-03', true)
assert_match(f6, '2023-07-03', true)
assert_match(f6, '2023-06-03', false)
puts "Next after 2023-01-05: #{f6.next_occurrence(after: Date.parse('2023-01-05'))} (Expected 2023-07-03)"

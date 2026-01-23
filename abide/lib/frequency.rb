require 'date'
require 'set'

class Frequency
  PERIODS = [:day, :week, :month, :year, :once].freeze
  MONTHS = {
    jan: 1, feb: 2, mar: 3, apr: 4, may: 5, jun: 6,
    jul: 7, aug: 8, sep: 9, oct: 10, nov: 11, dec: 12
  }.freeze
  DAYS = {
    sunday: 0, monday: 1, tuesday: 2, wednesday: 3,
    thursday: 4, friday: 5, saturday: 6
  }.freeze

  attr_reader :period, :interval, :on, :months, :nth

  def initialize(period:, interval: 1, on: nil, months: nil, nth: nil)
    @period = period.to_sym
    @interval = interval
    @on = Array(on) if on
    @months = normalize_months(months)
    @nth = nth

    validate!
  end

  # Fluent Factories
  def self.once(on:)
    # 'on' is a Date object here
    new(period: :once, on: on)
  end

  def self.daily(interval: 1)
    new(period: :day, interval: interval)
  end

  def self.weekly(on: nil, interval: 1)
    new(period: :week, interval: interval, on: on)
  end

  def self.monthly(on:, interval: 1, nth: nil)
    new(period: :month, interval: interval, on: on, nth: nth)
  end

  def self.quarterly(on:, months: [:jan, :apr, :jul, :oct])
    new(period: :year, interval: 1, on: on, months: months)
  end

  def self.yearly(on:, months: nil)
    new(period: :year, interval: 1, on: on, months: months)
  end

  def include?(date)
    return @on.first == date if @period == :once

    # Check basic period/interval logic 
    # (Note: Interval logic > 1 requires a reference start date for simpler cases like "every 2 weeks", 
    # but for "Monthly" or "Yearly" defined by calendar fields, it matches the calendar fields directly.)
    
    return false unless month_matches?(date)
    return false unless day_matches?(date)
    
    true
  end

  def next_occurrence(after: Date.today)
    if @period == :once
      target_date = @on.first
      return target_date if target_date > after
      return nil
    end

    date = after + 1
    # Safety brake: try for 5 years approx
    (0..(365 * 5)).each do |day_offset|
      candidate = date + day_offset
      return candidate if include?(candidate)
    end
    nil
  end

  private

  def normalize_months(months_input)
    return nil unless months_input
    Array(months_input).map do |m|
      m.is_a?(Integer) ? m : MONTHS[m.to_s.downcase.to_sym]
    end.compact.sort
  end

  def validate!
    raise ArgumentError, "Invalid period" unless PERIODS.include?(@period)
    
    if @period == :once
      # Ensure 'on' contains a Date
      unless @on&.first.is_a?(Date)
        raise ArgumentError, "Frequency.once requires a Date object for 'on'"
      end
    end
  end

  def month_matches?(date)
    return true if @period == :day || @period == :week
    # For :month period, we match every month if interval is 1.
    # If interval > 1, we imply we need a reference start date to calculate stride?
    # For now, adhering to the "Calendar Pattern" where Monthly usually means "In the calendar month".
    # Complex intervals like "Every 2 months" are ambiguous without a start date. 
    # We will assume "Matches every month" if period is :month for this version unless logic is refined.
    
    if @period == :year
      return true if @months.nil? # Every month? Unlikely for yearly.
      return @months.include?(date.month)
    end

    true
  end

  def day_matches?(date)
    if @period == :week
      return true if @on.nil? || @on.empty?
      weekdays = @on.map { |d| d.is_a?(Integer) ? d : DAYS[d.to_s.downcase.to_sym] }
      return weekdays.include?(date.wday)
    end

    if @period == :month || @period == :year
      # Case: Specific day of month (e.g., 3rd, 5th)
      if @nth.nil?
        return @on.include?(date.day)
      end

      # Case: "2nd Wednesday"
      # @on is likely [:wednesday] or :wednesday
      target_day_sym = @on.first
      target_wday = target_day_sym.is_a?(Integer) ? target_day_sym : DAYS[target_day_sym.to_s.downcase.to_sym]
      
      return false unless date.wday == target_wday
      return nth_wday_of_month?(date, @nth)
    end

    true
  end

  def nth_wday_of_month?(date, n)
    # n=1 (1st), n=2 (2nd), ..., n=-1 (last)
    return false unless date.month == date.month # Sanity

    if n > 0
      # Is this the nth occurrence?
      # (Day - 1) / 7 gives the completed weeks before this day.
      # 1st to 7th is week 0 for "nth" calc purposes?
      # (1-1)/7 = 0. (7-1)/7 = 0. (8-1)/7 = 1.
      # So nth is ((date.day - 1) / 7) + 1
      occurence_index = ((date.day - 1) / 7) + 1
      return occurence_index == n
    elsif n == -1
      # Last occurrence
      days_in_month = Date.new(date.year, date.month, -1).day
      return (date.day + 7) > days_in_month
    end
    false
  end
end

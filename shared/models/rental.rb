# frozen_string_literal: true

require 'Date'

# Service to build a single rental entity
class Rental
  DISCOUNT_BREAKS = {
    10 => 0.5,
    4 => 0.7,
    1 => 0.9,
    0 => 1
  }.freeze

  attr_reader :id, :start_date, :end_date, :distance

  def initialize(args)
    @id = args['id']
    @car_id = args['car_id']
    @start_date = args['start_date']
    @end_date = args['end_date']
    @distance = args['distance']
  end

  def total_days
    return 1 if start_date.nil? || end_date.nil?

    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  def discounted_days
    remaining_days = total_days
    discounted_days = 0
    DISCOUNT_BREAKS.each do |d, r|
      next unless remaining_days > d

      applicable_days = remaining_days - d
      discounted_days += (applicable_days * r).round(2)
      remaining_days -= applicable_days
    end
    discounted_days
  end
end

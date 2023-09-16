# frozen_string_literal: true

# Service to calculate price of rental using car's properties
class PriceCalculator
  attr_reader :days, :distance, :car

  def initialize(args)
    @days = args[:days]
    @distance = args[:distance]
    @car = args[:car]
  end

  def total_price
    (price_by_distance + price_by_day).to_i
  end

  def price_by_distance
    return 0 if distance.nil? || car.price_per_km.nil?

    distance * car.price_per_km
  end

  def price_by_day
    return 0 if days.nil? || car.price_per_day.nil?

    days * car.price_per_day
  end
end

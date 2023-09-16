# frozen_string_literal: true

# Service to build a collection of options
class OptionsBuilder
  OPTION_PRICES = {
    gps: 5,
    baby_seat: 2,
    additional_insurance: 10
  }.freeze
  CONVERSION_RATE = 100

  attr_reader :options, :days

  def initialize(options, days)
    @options = options
    @days = days
  end

  def call
    options.each_with_object({}) do |opt, res|
      type = opt['type']
      res[type] = option_total_price(type)
    end
  end

  private

  def option_total_price(type)
    OPTION_PRICES[type.to_sym] * CONVERSION_RATE * days
  end
end

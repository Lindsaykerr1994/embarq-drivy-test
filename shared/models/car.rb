# frozen_string_literal: true

# Service to build a single car entity
class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(args)
    @id = args['id']
    @price_per_day = args['price_per_day']
    @price_per_km = args['price_per_km']
  end
end

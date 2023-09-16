# frozen_string_literal: true

require '../shared/services/file_service'
require '../shared/services/price_calculator'
require '../shared/models/rental'
require '../shared/models/car'

# Service to build rental prices from a collection of data
class RentalPricesBuilder
  attr_reader :file_service, :data, :cars, :rentals

  def initialize
    @file_service = FileService.new
    @data = file_service.import_data
    @cars = data.fetch('cars', [])
    @rentals = data.fetch('rentals', [])
  end

  def call
    return if cars.nil? || rentals.nil?

    file_service.export_data(build_output_obj(rentals))
  end

  private

  def build_car(car_id)
    Car.new(cars.find { |c| c['id'] == car_id })
  end

  def build_rental(r_obj)
    Rental.new(r_obj.merge(car: build_car(r_obj['car_id'])))
  end

  def calculate_price(rental, car)
    PriceCalculator.new(days: rental.total_days,
                        distance: rental.distance,
                        car: car).total_price
  end

  def build_output_obj(rentals)
    rentals.each_with_object({}) do |r, hash|
      rental = build_rental(r)
      car = build_car(r['car_id'])
      hash['rentals'] ||= []
      hash['rentals'].push({ 'id': rental.id,
                             'price': calculate_price(rental, car) })
    end
  end
end

RentalPricesBuilder.new.call

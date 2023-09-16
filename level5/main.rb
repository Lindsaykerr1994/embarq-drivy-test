# frozen_string_literal: true

require '../shared/services/file_service'
require '../shared/services/payment_actions_builder'
require '../shared/models/rental'
require '../shared/models/car'
require '../shared/models/options'

# Service to build rental prices from a collection of data
class RentalPricesBuilder
  attr_reader :file_service, :cars, :rentals, :options

  def initialize
    @file_service = FileService.new
    @data = file_service.import_data
    @cars = @data.fetch('cars', [])
    @rentals = @data.fetch('rentals', [])
    @options = @data.fetch('options', [])
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

  def build_options(r_id, days)
    rental_options = options.find_all { |option| option['rental_id'] == r_id }
    OptionsBuilder.new(rental_options, days).call
  end

  def build_payment_actions(rental, car, options)
    PaymentActionsBuilder.new(rental: rental,
                              car: car,
                              options: options).call
  end

  def build_output_obj(rentals)
    rentals.each_with_object({}) do |r, hash|
      rental = build_rental(r)
      car = build_car(r['car_id'])
      options = build_options(rental.id, rental.total_days)
      payment_actions = build_payment_actions(rental, car, options)
      hash['rentals'] ||= []
      hash['rentals'].push({ 'id': rental.id,
                             'options': options.keys,
                             'actions': payment_actions })
    end
  end
end

RentalPricesBuilder.new.call

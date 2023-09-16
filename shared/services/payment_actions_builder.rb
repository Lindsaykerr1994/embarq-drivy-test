# frozen_string_literal: true

require '../shared/services/price_calculator'
require '../shared/services/commissions_calculator'

# Delegate fees into payments and payment type for each role for an individual rental agreement
class PaymentActionsBuilder
  ROLES = {
    "driver": 'debit',
    "owner": 'credit',
    "insurance": 'credit',
    "assistance": 'credit',
    "drivy": 'credit'
  }.freeze

  attr_reader :rental, :car

  def initialize(args)
    @rental = args[:rental]
    @car = args[:car]
  end

  def call
    ROLES.map do |role, type|
      role_method = "#{role}_fee"
      { "who": role,
        "type": type,
        "amount": respond_to?(role_method) ? send(role_method) : commissions.send(role_method) }
    end
  end

  def driver_fee
    price
  end

  def owner_fee
    price - commissions.total_commissions
  end

  private

  def price
    @price ||= PriceCalculator.new(days: rental.discounted_days,
                                   distance: rental.distance,
                                   car: car).total_price
  end

  def commissions
    @commissions ||= CommissionsCalculator.new(rental.total_days, price)
  end
end

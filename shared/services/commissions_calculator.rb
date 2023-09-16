# frozen_string_literal: true

# Service to calculate total commissions from total rental price
class CommissionsCalculator
  COMMISSION_ROLES = %i[insurance_fee assistance_fee drivy_fee].freeze
  COMMISSION_RATE = 0.3
  INSURANCE_RATE = 0.5
  ASSISTANCE_RATE = 100

  attr_reader :days, :price

  def initialize(days, price)
    @days = days
    @price = price
  end

  def call
    return {} if price.nil?

    COMMISSION_ROLES.each_with_object({}) { |role, res| res[role] = send(role) }
  end

  def total_commissions
    @total_commissions ||= (price * COMMISSION_RATE).to_i
  end

  def insurance_fee
    @insurance_fee ||= (total_commissions * INSURANCE_RATE).to_i
  end

  def assistance_fee
    @assistance_fee ||= days * ASSISTANCE_RATE
  end

  def drivy_fee
    total_commissions - (insurance_fee + assistance_fee)
  end
end

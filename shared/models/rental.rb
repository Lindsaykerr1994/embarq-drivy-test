# frozen_string_literal: true

require 'Date'

# Service to build a single rental entity
class Rental
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
end

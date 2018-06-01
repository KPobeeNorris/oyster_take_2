require_relative 'journey'

class OysterCard

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  attr_reader :balance, :journey_log, :journey

  def initialize
    @balance = 0
    @journey_log =[]
    @journey = Journey.new
  end

  def top_up(amount)
    fail "Sorry, you've hit the maximum balance of #{MAX_BALANCE}" if (balance + amount) > MAX_BALANCE
    @balance += amount
  end

  def touch_in(station)
    fail "Sorry, you don't have the required minimum balance of #{MIN_BALANCE}" if balance < 1
    if @journey.journey[:entry_station] != nil
      reset_journey
    end
    @journey.start_journey(station)
    in_journey?
  end

  def touch_out(station)
    @journey.end_journey(station)
    reset_journey
    in_journey?
  end

  def in_journey?
    @journey.journey[:entry_station] != nil
  end

  def reset_journey
    journey_log << @journey.journey
    deduct(@journey.fare)
    @journey.journey = { entry_station: nil, entry_zone: nil, exit_station: nil, exit_zone: nil }
  end

  private

  def deduct(fare)
    @balance -= fare
  end
end

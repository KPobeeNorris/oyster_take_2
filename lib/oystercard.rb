require_relative 'journey_log'

class OysterCard

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  attr_reader :balance, :journey_log

  def initialize
    @balance = 0
    @journey_log = JourneyLog.new
  end

  def top_up(amount)
    fail "Sorry, you've hit the maximum balance of #{MAX_BALANCE}" if (balance + amount) > MAX_BALANCE
    @balance += amount
  end

  def touch_in(station)
    fail "Sorry, you don't have the required minimum balance of #{MIN_BALANCE}" if balance < MIN_BALANCE
    no_touch_out
    @journey_log.start(station)
    in_journey?
  end

  def touch_out(station)
    @journey_log.finish(station)
    deduct(@journey_log.journey.fare)
    @journey_log.clear_current_journey
    in_journey?
  end

  def in_journey?
    @journey_log.journey.journey[:entry_station] != nil
  end

  private

  def no_touch_out
    if @journey_log.journey.journey[:entry_station] != nil
      @journey_log.record_journey
      deduct(@journey_log.journey.fare)
      @journey_log.clear_current_journey
    end
  end

  def deduct(fare)
    @balance -= fare
  end
end

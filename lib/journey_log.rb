require_relative 'station'
require_relative 'journey'

class JourneyLog

  attr_reader :journey_log, :journey

  def initialize
    @journey_log = []
    clear_current_journey
  end

  def clear_current_journey
    @journey = Journey.new
  end

  def start(station)
    @journey.journey[:entry_station] = station.name
    @journey.journey[:entry_zone] = station.zone
  end

  def finish(station)
    @journey.journey[:exit_station] = station.name
    @journey.journey[:exit_zone] = station.zone
    record_journey
  end

  def record_journey
    @journey_log << @journey.journey
  end
end

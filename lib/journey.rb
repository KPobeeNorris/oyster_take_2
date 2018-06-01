class Journey
  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_accessor :journey

  def initialize
    @journey = { entry_station: nil, entry_zone: nil, exit_station: nil, exit_zone: nil }
  end

  def start_journey(station)
    @journey[:entry_station] = station.name
    @journey[:entry_zone] = station.zone
  end

  def end_journey(station)
    @journey[:exit_station] = station.name
    @journey[:exit_zone] = station.zone
  end

  def fare
    journey_complete? ? MIN_FARE : PENALTY_FARE
  end

  def journey_complete?
    journey[:entry_station] != nil && journey[:exit_station] != nil
  end
end

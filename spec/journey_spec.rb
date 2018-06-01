require 'journey'

RSpec.describe Journey do

  let(:entry_station) { double name: "entry_station", zone: 1 }
  let(:exit_station)  { double name: "exit_station", zone: 3 }

  describe '#start_journey' do
    it "will record the entry station" do
      subject.start_journey(entry_station)
      expect(subject.journey[:entry_station]).to eq "entry_station"
    end
  end

  describe '#end_journey' do
    it "will reset the journey to be empty" do
      subject.end_journey(exit_station)
      expect(subject.journey).to be {}
    end
  end

  describe '#fare' do
    it "will charge a penalty fare if not touched in or out" do
      subject.end_journey(exit_station)
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end

    it "will charge a normal fare if no issues" do
      subject.start_journey(entry_station)
      subject.end_journey(exit_station)
      expect(subject.fare).to eq Journey::MIN_FARE
    end

  end

  describe '#journey_complete?' do
    it "will return false if journey not complete" do
      subject.end_journey(exit_station)
      expect(subject.journey_complete?).to be false
    end

    it "will return true if journey completed" do
      subject.start_journey(entry_station)
      subject.end_journey(exit_station)
      expect(subject.journey_complete?).to be true
    end
  end
end

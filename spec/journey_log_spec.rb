RSpec.describe JourneyLog do
  let(:entry_station) { double name: "entry_station", zone: 1 }
  let(:exit_station)  { double name: "exit_station", zone: 3 }

  describe '#initialize' do
    it "will have no journey history on initialisation" do
      expect(subject.journey_log).to eq []
    end

    it { is_expected.to respond_to(:journey).with(0).arguments }
  end

  describe '#start' do
    it "will record the entry station" do
      subject.start(entry_station)
      expect(subject.journey.journey[:entry_station]).to eq "entry_station"
    end
  end

  describe '#finish' do
    it "will reset the journey to be empty" do
      subject.finish(exit_station)
      expect(subject.journey).to be {}
    end

    it "records the exit station of the journey" do
      subject.start(entry_station)
      subject.finish(exit_station)
      expect(subject.journey_log.last).to eq(:entry_station=>"entry_station", :entry_zone=>1, :exit_station=>"exit_station", :exit_zone=>3)
    end
  end

  describe "journey history" do
    it "will keep a log of a complete journey" do
      subject.start(entry_station)
      subject.finish(exit_station)
      expect(subject.journey_log).to eq [{:entry_station=>"entry_station", :entry_zone=>1, :exit_station=>"exit_station", :exit_zone=>3}]
    end

    it "will record an incomplete journey" do
      subject.finish(exit_station)
      expect(subject.journey_log).to eq [{:entry_station=>nil, :entry_zone=>nil, :exit_station=>"exit_station", :exit_zone=>3}]
    end
  end
end

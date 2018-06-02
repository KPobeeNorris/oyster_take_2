RSpec.describe Journey do

  let(:entry_station) { double name: "entry_station", zone: 1 }
  let(:exit_station)  { double name: "exit_station", zone: 3 }

  it {is_expected.to respond_to(:finish).with(1).argument}
  it {is_expected.to respond_to(:complete?).with(0).arguments}
  it {is_expected.to respond_to(:fare).with(0).arguments}

  describe '#start' do
    it "will record the entry station" do
      subject.start(entry_station)
      expect(subject.journey[:entry_station]).to eq "entry_station"
    end
  end

  describe '#finish' do
    it "will reset the journey to be empty" do
      subject.finish(exit_station)
      expect(subject.journey).to be {}
    end
  end

  describe '#fare' do
    it "will calculate a penalty fare if not touched in or out" do
      subject.finish(exit_station)
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end

    it "will calculate a normal fare if complete journey" do
      subject.start(entry_station)
      subject.finish(exit_station)
      expect(subject.fare).to eq Journey::MIN_FARE
    end

  end

  describe '#complete?' do
    it "will return false if journey not complete" do
      subject.finish(exit_station)
      expect(subject.complete?).to be false
    end

    it "will return true if journey completed" do
      subject.start(entry_station)
      subject.finish(exit_station)
      expect(subject.complete?).to be true
    end
  end
end

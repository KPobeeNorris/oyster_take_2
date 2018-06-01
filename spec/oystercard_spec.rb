require 'oystercard'

RSpec.describe OysterCard do

  let(:entry_station) { double name: "entry_station", zone: 1 }
  let(:exit_station)  { double name: "exit_station", zone: 3 }

  def touch_in
    subject.top_up(OysterCard::MIN_BALANCE)
    subject.touch_in(entry_station)
  end

  it "will be initialised with a balance of 0" do
    expect(subject.balance).to eq 0
  end

  it "will have no journey history on initialisation" do
    expect(subject.journey_log).to eq []
  end

  describe '#top_up' do

    it {is_expected.to respond_to(:top_up).with(1).argument}

    it "will top up the OysterCard balance" do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it "will have a maximum top up limit on the card" do
      subject.top_up(OysterCard::MAX_BALANCE)
      expect{ subject.top_up(1) }.to raise_error(RuntimeError, "Sorry, you've hit the maximum balance of #{OysterCard::MAX_BALANCE}")
    end
  end

  describe '#touch_in' do
    it "will raise an error if the balance is below the minimum threshold" do
      expect{ subject.touch_in(entry_station) }.to raise_error(RuntimeError, "Sorry, you don't have the required minimum balance of #{OysterCard::MIN_BALANCE}")
    end

    it "will show as being in journey" do
      touch_in
      expect(subject.in_journey?).to be true
    end
  end

  describe '#touch_out' do
    it "will change the in use status to false" do
      touch_in
      subject.touch_out(exit_station)
      expect(subject.in_journey?).to be false
    end

    it "will deduct the minimum fare" do
      touch_in
      expect{subject.touch_out(exit_station)}.to change{subject.balance}.by(-Journey::MIN_FARE)
    end

    it "will deduct a penalty fare" do
      touch_in
      expect{subject.touch_in(entry_station)}.to change{subject.balance}.by(-Journey::PENALTY_FARE)
    end
  end

  describe "journey history" do
    it "will keep a log of a full journey" do
      touch_in
      subject.touch_out(exit_station)
      expect(subject.journey_log).to eq [{:entry_station=>"entry_station", :entry_zone=>1, :exit_station=>"exit_station", :exit_zone=>3}]
    end

    it "will record an imcomplete journey" do
      touch_in
      touch_in
      subject.touch_out(exit_station)
      expect(subject.journey_log).to eq [{:entry_station=>"entry_station", :entry_zone=>1, :exit_station=>nil, :exit_zone=>nil}, {:entry_station=>"entry_station", :entry_zone=>1, :exit_station=>"exit_station", :exit_zone=>3}]
    end
  end
end

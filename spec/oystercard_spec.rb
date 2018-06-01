require 'oystercard'

RSpec.describe OysterCard do

  it "will be initialized with a balance of 0" do
    expect(subject.balance).to eq 0
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
    it "will change the in use status to true" do
      subject.top_up(OysterCard::MIN_BALANCE)
      expect{subject.touch_in}.to change{subject.in_journey}.to true
    end

    it "will raise an error if the balance is below the minimum threshold" do
      expect{ subject.touch_in }.to raise_error(RuntimeError, "Sorry, you don't have the required minimum balance of #{OysterCard::MIN_BALANCE}")
    end
  end

  describe '#touch_out' do
    it "will change the in use status to false" do
      subject.top_up(OysterCard::MIN_BALANCE)
      subject.touch_in
      expect{subject.touch_out}.to change{subject.in_journey}.to false
    end

    it "will deduct the minimum fare" do
      subject.top_up(OysterCard::MIN_BALANCE)
      subject.touch_in
      expect{subject.touch_out}.to change{subject.balance}.by(-OysterCard::MIN_FARE)
    end
  end

  describe '#in_journey?' do

    it "will initially not be in journey" do
      expect(subject.in_journey?).to be false
    end

    it "will return true if user has touched in" do
      subject.top_up(OysterCard::MIN_BALANCE)
      subject.touch_in
      expect(subject.in_journey?).to be true
    end

    it "will return true if user has touched out" do
      subject.touch_out
      expect(subject.in_journey?).to be false
    end
  end
end

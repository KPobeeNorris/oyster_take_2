class OysterCard

  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_FARE = 1

  attr_reader :balance, :in_journey

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    if
      balance + amount > MAX_BALANCE
      raise "Sorry, you've hit the maximum balance of #{MAX_BALANCE}"
    else
      @balance += amount
    end
  end

  def touch_in
    fail "Sorry, you don't have the required minimum balance of #{MIN_BALANCE}" if balance < 1
    @in_journey = true
  end

  def touch_out
    deduct(MIN_FARE)
    @in_journey = false
  end

  def in_journey?
    in_journey == true
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end

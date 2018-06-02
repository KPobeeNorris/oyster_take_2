RSpec.describe Station do

  subject { described_class.new("Bank", 1) }

  it "will have a name on initialisation" do
    expect(subject.name).to eq "Bank"
  end

  it "will have a zone on initialisation" do
    expect(subject.zone).to eq 1
  end
end

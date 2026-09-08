require_relative "../xor/xor"

RSpec.describe "XOR" do
  describe "#xor_byte" do
    it "xors a byte with a key" do
      expect(xor_byte(0b10101010, 0b11110000))
        .to eq(0b01011010)
    end
  end
end

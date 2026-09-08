require_relative "../algo/xor"

RSpec.describe RCrypt::XOR do
  describe ".encrypt" do
    it "encrypts text using a repeating XOR key" do
      result = described_class.encrypt("hello world", key: "flower")

      expect(result). to eq ("0e09031b0a5211031d1b01")
    end
  end

  describe ".decrypt" do
    it "decrypts hexadecimal ciphertext" do
      result = described_class.decrypt("0e09031b0a5211031d1b01", key: "flower")

      expect(result).to eq ("hello world")
    end
  end

  describe "full-cycle" do
    it "recovers the original plaintext" do
      plaintext = "difference and"
      key = "repetition"

      ciphertext = described_class.encrypt(plaintext, key: key)
      recovered = described_class.decrypt(ciphertext, key: key)

      expect(recovered).to eq(plaintext)
    end
  end
end

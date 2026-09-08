require_relative "../vigenere/vigenere"

RSpec.describe RCrypt::Vigenere do
  describe ".encrypt" do
    it "encrypts using a repeating alphabetic key" do
      result = described_class.encrypt("HELLO", key: "FLOWER")

      expect(result).to eq ("MPZHS")
    end
  end

  # Molecular test (?)
  # Check each byte is shifted

  describe "full-cycle" do
    it "recovers the original text" do
      plaintext = "HELLO WORLD"
      key = "FLOWER"

      ciphertext =  described_class.encrypt(plaintext, key: key)
      recovered = described_class.decrypt(ciphertext, key: key)

      expect(recovered).to eq(plaintext)
    end
  end
end

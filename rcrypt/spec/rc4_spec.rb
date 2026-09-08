require_relative "../algo/rc4"

RSpec.describe RCrypt::RC4 do
  describe ".encrypt" do
    it "matches a known RC4 test vector" do
      result = described_class.encrypt("Plaintext", key: "Key")

      expect(result).to eq("bbf316e8d940af0ad3")
    end
  end

  describe ".decrypt" do
    it "decrypts the known test vector" do
      result = described_class.decrypt("bbf316e8d940af0ad3", key: "Key")

      expect(result).to eq("Plaintext")
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

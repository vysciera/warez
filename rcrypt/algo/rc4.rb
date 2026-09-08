module RCrypt
  module RC4
    def self.encrypt(text, key:)
      apply(text, key).unpack1("H*")
    end

    def self.decrypt(ciphertext, key:)
      validate_hex!(ciphertext)

      bytes = [ciphertext].pack("H*")
      apply(bytes, key)
    end

    def self.apply(data, key)
      raise ArgumentError, "key cannot be empty" if key.empty?

      s = key_schedule(key)
      i = 0
      j = 0

      output = data.bytes.map do |byte|
        i = (i + 1) % 256
        j = (j + s[i]) % 256

        s[i], s[j] = s[j], s[i]

        k = s[(s[i] + s[j]) % 256]

        byte ^ k
      end

      output.pack("C*")
    end

    def self.key_schedule(key)
      s = (0..255).to_a
      key_bytes = key.bytes

      j = 0

      256.times do |i|
        j = (j + s[i] + key_bytes[i % key_bytes.length]) % 256

        s[i], s[j] = s[j], s[i]
      end

      s
    end

    def self.validate_hex!(text)
      valid = !text.empty? && text.length.even? && text.match?(/\A[0-9a-fA-F]+\z/)

      raise ArgumentError, "invalid hexadecimal ciphertext" unless valid
    end

  end
end

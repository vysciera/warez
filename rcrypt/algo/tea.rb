module RCrypt
  module TEA
      MASK = 0xffffffff
      DELTA = 0x9e3779b9

      BLOCK_SIZE = 8
      KEY_SIZE = 16
      ROUNDS = 32

      def self.encrypt(text, key:)
        validate_key!(key)

        padded = pad(text)

        encrypted = padded.bytes.each_slice(BLOCK_SIZE).map do |bytes|
          encrypt_block(bytes.pack("C*"), key)
        end.join

        encrypted.unpack1("H*")
      end

      def self.decrypt(ciphertext, key:)
        validate_key!(key)
        validate_hex!(ciphertext)

        data = [ciphertext].pack("H*")

        unless (data.bytesize % BLOCK_SIZE).zero?
          raise ArgumentError, "invalid ciphertext length"
        end

        decrypted = data.bytes.each_slice(BLOCK_SIZE).map do |bytes|
          decrypt_block(bytes.pack("C*"), key)
        end.join

        unpad(decrypted)
      end

      def self.encrypt_block(block, key)
        v0, v1 = block.unpack("N2")
        k0, k1, k2, k3 = key.unpack("N4")

        sum = 0

        ROUNDS.times do
          sum = (sum + DELTA) & MASK

          v0 = (v0 + (((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1))) & MASK
          v1 = (v1 + (((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3))) & MASK
        end

        [v0, v1].pack("N2")
      end

      def self.decrypt_block(block, key)
        v0, v1 = block.unpack("N2")
        k0, k1, k2, k3 = key.unpack("N4")

        sum = (DELTA * ROUNDS) & MASK

        ROUNDS.times do
          v1 = (v1 - (((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3))) & MASK
          v0 = (v0 - (((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1))) & MASK

          sum = (sum - DELTA) & MASK
        end

        [v0, v1].pack("N2")
      end

      def self.pad(data)
        padding = BLOCK_SIZE - (data.bytesize % BLOCK_SIZE)

        data + padding.chr * padding
      end

      def self.unpad(data)
        padding = data.getbyte(-1)

        unless padding && padding.between?(1, BLOCK_SIZE) && data.byteslice(-padding, padding).bytes.all? { |b| b == padding }
          raise ArgumentError, "invalid padding"
        end

        data.byteslice(0, data.bytesize - padding)
      end

      def self.validate_key!(key)
        return if key.bytesize == KEY_SIZE

        raise ArgumentError, "TEA key must be exactly 16 bytes"
      end

      def self.validate_hex!(text)
        valid = !text.empty? && text.length.even? && text.match?(/\A[0-9a-fA-F]+\z/)

        raise ArgumentError, "invalid hexadecimal ciphertext" unless valid
      end    
  end
end

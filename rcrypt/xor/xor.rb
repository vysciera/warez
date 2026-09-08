module RCrypt
  module XOR
    
    # Use of Array#pack/String#unpack1
    # Native string manipulation methods, unpack extracts data from string and returns an array of objects
    # #unpack1 returns the first element of that array
    # #pack formats each element in an array into a binary string, returns
    
    # pack("H*") | unpack1("H*")
    # 'H' - Hex string (high nibble first)
    # '*" - Apply as many times as needed

    def self.encrypt(text, key:)
      apply(text, key).unpack1("H*")
    end

    def self.decrypt(ciphertext, key:)
      validate_hex!(ciphertext)

      bytes = [ciphertext].pack("H*")
      apply(bytes, key)
    end

    # text: hello world
    # key: flower
    # =====================
    # plaintext: h e l l o   w o r l d
    # key:       f l o w e r f l o w e


    def self.apply(data, key)
      raise ArgumentError, "key cannot be empty" if key.empty?

      key_bytes = key.bytes

      data.bytes.each_with_index.map do |byte, index|
        byte ^ key_bytes[index % key_bytes.length] # XOR 
      end.pack("C*")
    end

    # Evil regex stuff
    def self.validate_hex!(text)
      valid =
        !text.empty? && text.length.even? && text.match?(/\A[0-9a-fA-F]+\z/)

      raise ArgumentError, "invalid hexadecimal ciphertext" unless valid
    end

  end
end

module RCrypt
  module Vigenere
    def self.encrypt(text, key:)
      transform(text, key, 1)
    end

    def self.decrypt(text, key:)
      transform(text, key, -1)
    end

    def self.transform(text, key, direction)
      shifts = key_shifts(key)
      key_index = 0

      text.each_char.map do |char|
        unless letter?(char)
          next char
        end

        shift = shifts[key_index % shifts.length]
        key_index += 1

        shift_char(char, shift * direction)
      end.join
    end

    def self.key_shifts(key)
      raise ArgumentError, "key cannot be empty" if key.empty?

      unless key.match?(/\A[a-zA-Z]+\z/)
        raise ArgumentError, "key must contain letters only"
      end

      key.downcase.bytes.map do |byte|
        byte - "a".ord
      end
    end

    def self.shift_char(char, shift)
      base =
        if char.between?("a", "z") # absurd
          "a".ord
        else
          "A".ord
        end

      offset = char.ord - base
      ((offset + shift) % 26 + base).chr
    end

    def self.letter?(char) # ¯\_(ツ)_/¯
      char.between?("a", "z") || char.between?("A", "Z")
    end
  end
end

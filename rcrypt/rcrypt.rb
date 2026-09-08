require "optparse"

algorithms = {
  "xor" => {
    path: "./xor/xor", # Tasteful, really.
    implementation: -> { RCrypt::XOR }
  }
}.freeze

options = {
  action: nil,
  key: nil
}

algorithm_name = ARGV.shift

parser = OptionParser.new do |opts|
  opts.banner = <<~USAGE
    Usage:
      ruby rcrypt.rb <algorithm> <-E|-D> <text> -k <key>

    Examples:
      ruby rcrypt.rb xor -E "hello world" -k flower
      ruby rcrypt.rb xor -D "0e09031b..." -k flower
  USAGE

  opts.on("-E", "--encrypt", "Encrypt text") do
    options[:action] = :encrypt
  end

  opts.on("-D", "--decrypt", "Decrypt text") do
    options[:action] = :decrypt
  end

  opts.on("-k", "--key KEY", "Encryption/decryption key") do |key|
    options[:key] = key
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end

parser.parse!

unless algorithm_name
  warn "error: algorithm required"
  exit 1
end

config = ALGORITHMS[algorithm_name]

unless config
  warn "error: unknown algorithm '#{algorithm_name}'"
  exit 1
end

unless options[:action]
  warn "error: action not specified (encrypt/decrypt)"
  exit 1
end

unless options[:key]
  warn "error: key required"
  exit 1
end

text = ARGV.join(" ")

if text.empty?
  warn "error: text required"
  exit 1
end

require_relatie config[:path]

algorithm = config[:implementation].call

result =
  case options[:action]
  when :encrypt
    algorithm.encrypt(text, key: options[:key])

  when :decrypt
      algorithm.decrypt(text, key: options[:key])
  end

puts result

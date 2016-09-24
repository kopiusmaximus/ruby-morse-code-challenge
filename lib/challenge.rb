
require 'pry'

MORSE_CODE = {
  '.-' => 'A', '-...' => 'B', '-.-.' => 'C', '-..' => 'D', '.' => 'E',
  '..-.' => 'F', '--.' => 'G', '....' => 'H', '..' => 'I', '.---' => 'J',
  '-.-' => 'K', '.-..' => 'L', '--' => 'M', '-.' => 'N', '---' => 'O',
  '.--.' => 'P', '--.-' => 'Q', '.-.' => 'R', '...' => 'S', '-' => 'T',
  '..-' => 'U', '...-' => 'V', '.--' => 'W', '-..-' => 'X', '-.--' => 'Y',
  '--..' => 'Z', '-----' => '0', '.----' => '1', '..---' => '2', '...--' => '3',
  '....-' => '4', '.....' => '5', '-....' => '6', '--...' => '7',
  '---..' => '8', '----.' => '9', '.-.-.-' => '.', '--..--' => ',',
  '..--..' => '?', '.----.' => "'", '-.-.--' => '!', '-..-.' => '/',
  '-.--.' => '(', '-.--.-' => ')', '.-...' => '&', '---...' => ':',
  '-.-.-.' => ';', '-...-' => '=', '.-.-.' => '+', '-....-' => '-',
  '..--.-' => '_', '.-..-.' => '"', '...-..-' => '$', '.--.-.' => '@',
  '...---...' => 'SOS'
}.freeze
## DO NOT CHANGE ANYTHING ABOVE THIS LINE

def decode_morse(morse_code)
  morse_words = morse_code.split('   ').map { |m_word| m_word.split(' ') }
  morse_words.map do |morse_word|
    morse_word.map do |morse_char|
      MORSE_CODE[morse_char] ? MORSE_CODE[morse_char] : '*'
    end.join
  end.join(' ')
end

# removes any leading and trailing zeroes from a binary string
def trim_silence(bits)
  bits.sub!(/^0*/, '').sub!(/0*$/, '')
end

# determines the shortest stretch of ones in a binary string
def calculate_time_scale(bits)
  bits.scan(/1+/).min_by(&:length).length
end

def split_bits_into_bit_words(bits, time_scale)
  word_space = '0000000' * time_scale
  char_space = '000' * time_scale
  bits.split(word_space).map { |bit_word| bit_word.split(char_space) }
end

def convert_bit_char_to_morse_char(bit_char, time_scale)
  dot = '1' * time_scale
  d_space = '0' * time_scale
  bit_char.split(d_space).map do |d|
    d == dot ? '.' : '-'
  end.join
end

def parse_bits(bits)
  bits = trim_silence(bits)
  time_scale = calculate_time_scale(bits)

  # parse the bit string into dots & dashes and return a string of Morse code
  bit_words = split_bits_into_bit_words(bits, time_scale)
  bit_words.map do |bit_word|
    bit_word.map do |bit_char|
      convert_bit_char_to_morse_char(bit_char, time_scale)
    end.join(' ')
  end.join('   ')
end

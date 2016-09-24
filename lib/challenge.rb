
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

def trim_silence(bits)
  bits.sub!(/^0*/, '').sub!(/0*$/, '')
end

def parse_bits(bits)
  # trim 'silence', i.e. remove any leading and trailing zeroes
  bits = trim_silence(bits)

  # determine shortest stretch of ones: this is the time scale
  time_scale = bits.scan(/1+/).min_by(&:length).length

  # calibrate dots, dashes, and spaces using the time scale
  dot = '1' * time_scale
  word_space = '0000000' * time_scale
  char_space = '000' * time_scale
  d_space = '0' * time_scale

  # parse the bit string into dots & dashes and return a string of Morse code
  bit_words = bits.split(word_space).map { |b_word| b_word.split(char_space) }
  bit_words.map do |b_word|
    b_word.map do |b_char|
      b_char.split(d_space).map do |d|
        d == dot ? '.' : '-'
      end.join
    end.join(' ')
  end.join('   ')
end

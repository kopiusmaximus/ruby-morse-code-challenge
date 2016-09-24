require_relative '../lib/challenge.rb'

RSpec.describe 'Challenge: ' do
  describe '#decode_morse' do
    context 'with valid morse code input' do
      it 'handles alphanumeric messages' do
        expect(decode_morse('.- -... -.-.')).to eq('ABC')
        expect(decode_morse('.---- ..--- ...--')).to eq('123')
      end
      it 'handles spaces correctly' do
        expect(decode_morse('-.. ---   .-. .   -- ..')).to eq('DO RE MI')
      end
      it 'handle punctuation' do
        message = '.- --..--   -... --..--   -.-. -.-.-.   '
        message += '- .... .- - .----. ...   .... --- .--   . .- ... -.--   '
        message += '.-.. --- ...- .   -.-. .- -.   -... . -.-.--'
        expect(
          decode_morse(message)
        ).to eq("A, B, C; THAT'S HOW EASY LOVE CAN BE!")
      end
    end
    context 'with invalid input' do
      it 'replaces any invalid characters with asterisks' do
        expect(decode_morse('-.. ------   .-. .   -- ......')).to eq('D* RE M*')
      end
    end
  end

  describe '#parse_bits' do
    context 'at any discernable time unit' do
      it 'converts a string of ones and zeros into dots and dashes' do
        expect(parse_bits('10101011101110111010101')).to eq('...---...')
        abc = '10111000111010101000111010111010'
        expect(parse_bits(abc)).to eq('.- -... -.-.')
        expect(parse_bits(abc.gsub('(1|0)', '\1\1'))).to eq('.- -... -.-.')
        expect(parse_bits(abc.gsub('(1|0)', '\1\1\1'))).to eq('.- -... -.-.')
        expect(parse_bits(abc.gsub('(1|0)', '\1\1\1\1'))).to eq('.- -... -.-.')
      end
      it 'discards leading and trailing zeros' do
        expect(
          parse_bits('000000000000000000000010111000111010101000111010111010')
        ).to eq('.- -... -.-.')
        expect(
          parse_bits('10111000111010101000111010111010000000000000')
        ).to eq('.- -... -.-.')
      end
    end
    context 'an indeterminate time unit' do
      it 'assumes a time unit equal to the shortest set of 1s or \
        internal (i.e. not leading, not trailing) 0s' do
        expect(parse_bits('000000111111000000')).to eq('.')
        expect(parse_bits('111000111')).to eq('..')
        expect(parse_bits('111000000000111')).to eq('. .')
        expect(parse_bits('111111')).to eq('.')
        expect(parse_bits('1111111111111111111111111111111')).to eq('.')
      end
    end
  end
end

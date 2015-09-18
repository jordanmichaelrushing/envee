require 'spec_helper'

describe Envee do
  it 'has a version number' do
    expect(Envee::VERSION).not_to be nil
  end

  let(:env){{}.extend(described_class)}

  describe '#int' do
    context 'when requesting a value in env without default' do
      it 'returns env value casted as integer' do
        env['NUM'] = '1'
        expect(env.int('NUM')).to eq(1)
      end
    end

    context 'when requesting a value not in env with a default value' do
      it 'returns the default value casted as integer' do
        expect(env.int('NUM', '2')).to eq(2)
      end
    end

    context 'when requesting a value not in env with a default block' do
      it 'returns the default block value casted as integer' do
        expect(env.int('NUM'){'2'}).to eq(2)
      end
    end

    context 'when requesting a value not in env with no default' do
      it 'raises an KeyError' do
        expect{env.int('NUM')}.to raise_error(KeyError)
      end
    end

    context 'when requesting a value in env that cannot be casted to integer' do
      it 'raises an ArgumentError' do
        env['NUM'] = 'a'
        expect{env.int('NUM')}.to raise_error(ArgumentError)
      end
    end
  end

  describe '#str' do
    context 'when requesting a value in env without default' do
      it 'returns env value casted as string' do
        env['NUM'] = '1'
        expect(env.str('NUM')).to eq('1')
      end
    end

    context 'when requesting a value not in env with a default value' do
      it 'returns the default value casted as string' do
        expect(env.str('NUM', 2)).to eq('2')
      end
    end

    context 'when requesting a value not in env with a default block' do
      it 'returns the default block value casted as string' do
        expect(env.str('NUM'){2}).to eq('2')
      end
    end

    context 'when requesting a value not in env with no default' do
      it 'raises an KeyError' do
        expect{env.str('NUM')}.to raise_error(KeyError)
      end
    end
  end

  describe '#bool' do
    context 'when requesting a value in env without default' do
      it 'returns env value casted as truthy' do
        env['START'] = 'true'
        expect(env.bool('START')).to be_truthy
      end
    end

    context 'when requesting a value not in env with a default value' do
      it 'returns the default value casted as truthy' do
        expect(env.bool('START', '2')).to be_truthy
      end
    end

    context 'when requesting a value not in env with a default block' do
      it 'returns the default block value casted as integer' do
        expect(env.bool('START'){'2'}).to be_truthy
      end
    end

    %w(0 false no off).each do |false_value|
      context "when the env value is #{false_value}" do
        it 'returns a false value' do
          env['START'] = false_value
          expect(env.bool('START')).to be_falsy
        end
      end
    end

    context 'when requesting a value not in env with no default' do
      it 'raises an KeyError' do
        expect{env.bool('START')}.to raise_error(KeyError)
      end
    end
  end

  describe '#time' do
    context 'when requesting a value in env without default' do
      it 'returns env value casted as time' do
        env['TIME'] = '1970-01-01 00:00:00 UTC'
        expect(env.time('TIME')).to eq(Time.at(0))
      end
    end

    context 'when requesting a value not in env with a default value' do
      it 'returns the default value casted as time' do
        expect(env.time('TIME', '1970-01-01 00:00:01 UTC')).to eq(Time.at(1))
      end
    end

    context 'when requesting a value not in env with a default block' do
      it 'returns the default block value casted as time' do
        expect(env.time('TIME'){'1970-01-01 00:00:01 UTC'}).to eq(Time.at(1))
      end
    end

    context 'when requesting a value not in env with a default block and default already is a time' do
      it 'returns the default block value casted as time' do
        expect(env.time('TIME'){Time.at(1)}).to eq(Time.at(1))
      end
    end

    context 'when requesting a value not in env with no default' do
      it 'raises an KeyError' do
        expect{env.time('TIME')}.to raise_error(KeyError)
      end
    end

    context 'when requesting a value in env that cannot be casted to time' do
      it 'raises an ArgumentError' do
        env['TIME'] = 'a'
        expect{env.time('TIME')}.to raise_error(ArgumentError)
      end
    end
  end

  describe '#int_time' do
    context 'when requesting a value in env without default' do
      it 'returns env value casted as time' do
        env['TIME'] = '0'
        expect(env.int_time('TIME')).to eq(Time.at(0))
      end
    end

    context 'when requesting a value not in env with a default value' do
      it 'returns the default value casted as time' do
        expect(env.int_time('TIME', '1')).to eq(Time.at(1))
      end
    end

    context 'when requesting a value not in env with a default block' do
      it 'returns the default block value casted as time' do
        expect(env.int_time('TIME'){'1'}).to eq(Time.at(1))
      end
    end

    context 'when requesting a value not in env with no default' do
      it 'raises an KeyError' do
        expect{env.int_time('TIME')}.to raise_error(KeyError)
      end
    end

    context 'when requesting a value in env that cannot be casted to time' do
      it 'raises an ArgumentError' do
        env['TIME'] = 'a'
        expect{env.int_time('TIME')}.to raise_error(ArgumentError)
      end
    end
  end

  describe '#validate!' do
    context 'when no missing values are found' do
      it 'does not raise an error' do
        expect{env.validate!(missing_value: 'CHANGEME')}.to_not raise_error
      end
    end

    context 'when there are missing values' do
      it 'raises an error with all the missing values keys' do
        env['A'] = env['B'] = 'CHANGEME'
        expect{env.validate!(missing_value: 'CHANGEME')}.to raise_error(
          Envee::MissingValuesError,
          "The following environment variables are not set, but should be:\nB\nA\n"
        )
      end
    end
  end
end

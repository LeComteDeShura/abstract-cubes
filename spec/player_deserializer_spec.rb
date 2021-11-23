require_relative '../lib/ser_des/player_deserializer'

describe PlayerDeserializer do
  describe '#deserialize' do
    let(:hash) do
      {
        'health' => 40,
        'position' => Vector[1, 1, 1],
        'angle_rotation' => 3,
        'power' => 3
      }
    end

    subject { PlayerDeserializer.new(hash).deserialize }

    it { is_expected.to be_a Player }
    it { is_expected.to have_attributes hash.transform_keys(&:to_sym) }
  end
end

require_relative '../lib/player/player'
require_relative '../lib/ser_des/player_serializer'

describe PlayerSerializer do
  describe '#serialize' do
    let(:player) { Player.new }
    let(:expected_result) do
      {
        'health' => player.health,
        'position' => player.position,
        'angle_rotation' => player.angle_rotation,
        'power' => player.power
      }
    end

    subject { PlayerSerializer.new(player).serialize }

    it { is_expected.to be == expected_result }
  end
end

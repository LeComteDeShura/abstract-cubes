require_relative '../lib/enemy/enemy'

describe Enemy do
  describe '.new' do
    context 'without args' do
      subject { Enemy.new }

      it { expect(subject.color).to eq Vector[1, 0, 0.4, 0.5] }
      it { expect(subject.power).to eq 1 }
      it { expect(subject.radius_spawn).to eq 10 }
    end
    context 'with arg init_health >= 255' do
      subject do
        Enemy.new init_health = 1000,
                  radius_spawn = 10,
                  power = 2
      end

      it { expect(subject.color).to eq Vector[1, 0, 0.4, 0.5] }
      it { expect(subject.power).to eq 2 }
      it { expect(subject.radius_spawn).to eq 10 }
    end

    context 'with arg init_health < 255' do
      subject do
        Enemy.new init_health = 244,
                  radius_spawn = 10,
                  power = 2
      end

      it { expect(subject.color).to eq Vector[0.96, 0, 0.4, 0.5] }
      it { expect(subject.power).to eq 2 }
      it { expect(subject.radius_spawn).to eq 10 }
    end
  end

  describe '#dead?' do
    context 'health > 0' do
      let(:enemy) { Enemy.new(health = 10) }
      it { expect(enemy.dead?).to be false }
    end

    context 'health <= 0' do
      it {
        enemy = Enemy.new
        enemy.color = Vector[-10, 0, 0, 0]
        expect(enemy.dead?).to eq true
      }
    end
  end

  describe "#take_damage" do
    context 'health = 255, damage = 10' do
      let(:enemy) { Enemy.new health = 255 }
      it {
        expect(enemy.take_damage(10)).to eq 0.96
      }
    end
  end

  describe "#load" do
    context 'color = 0, position = 0, return self' do
      let(:enemy) { Enemy.new }
      it {
        expect(enemy.load(Vector[0, 0, 0], Vector[0, 0, 0, 0])).to eq enemy
      }
    end
  end

  describe "#spawn" do
    context 'position player = 0, difficult_game = 0, return self' do
      let(:enemy) { Enemy.new }
      it {
        expect(enemy.spawn(Vector[0, 0, 0], 0)).to eq enemy
      }
    end

    # context 'position player = 0, radius = 10, difficult_game = 0, position enemy = around player' do
    #   let(:enemy) { Enemy.new(radius_spawn=10)}
    #   it {
    #     enemy.spawn Vector[0,0,0], 0
    #     expect().to eq enemy
    #   }
    # end
  end

  describe "#do" do
    context 'position player = [0,0,0], position enemy = [10,1,0]' do
      let(:enemy) { Enemy.new }
      it {
        enemy.position = Vector[10, 1, 0]
        expect(enemy.do(Vector[0, 0, 0])).to eq true
        expect(enemy.position).to eq Vector[9, 1, 0]
      }
    end

    context 'position player = [0,0,0], position enemy = [1,0,0]' do
      let(:enemy) { Enemy.new }
      it {
        enemy.position = Vector[1, 0, 0]
        expect(enemy.do(Vector[0, 0, 0])).to eq false
        expect(enemy.position).to eq Vector[1, 0, 0]
      }
    end
  end
end

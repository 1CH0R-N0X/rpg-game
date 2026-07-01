class Reputation < ActiveRecord::Base
  self.table_name = 'reputations'

  belongs_to :character
  belongs_to :faction

  validates :character_id, :faction_id, presence: true

  # Reputation levels
  LEVELS = {
    hated: -100,
    distrusted: -50,
    unknown: 0,
    known: 20,
    respected: 50,
    revered: 100
  }.freeze

  def self.get_level_name(points)
    case points
    when -100...(-50) then 'Hated'
    when -50...0 then 'Distrusted'
    when 0...20 then 'Unknown'
    when 20...50 then 'Known'
    when 50...100 then 'Respected'
    when 100.. then 'Revered'
    else 'Unknown'
    end
  end

  def level_name
    self.class.get_level_name(points)
  end

  def to_api_hash
    {
      id: id,
      faction_id: faction_id,
      faction_name: faction.name,
      points: points,
      level_name: level_name
    }
  end
end

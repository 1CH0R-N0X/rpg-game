class BestiaryEntry < ActiveRecord::Base
  self.table_name = 'bestiary_entries'

  belongs_to :character

  validates :character_id, :creature_name, :creature_type, presence: true

  # Creature types
  TYPES = ['Humanoid', 'Beast', 'Undead', 'Elemental', 'Construct', 'Dragon', 'Giant', 'Fey', 'Aberration', 'Other'].freeze

  def to_api_hash
    {
      id: id,
      creature_name: creature_name,
      creature_type: creature_type,
      description: description,
      hp: hp,
      threat_level: threat_level,
      encounters_count: encounters_count,
      defeated_count: defeated_count,
      discovered_at: discovered_at
    }
  end
end

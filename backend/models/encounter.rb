class Encounter < ActiveRecord::Base
  self.table_name = 'encounters'

  belongs_to :character
  belongs_to :location, optional: true

  validates :character_id, :encounter_type, presence: true

  ENCOUNTER_TYPES = ['npc', 'combat', 'discovery', 'event'].freeze

  def to_api_hash
    {
      id: id,
      encounter_type: encounter_type,
      location_name: location&.name,
      description: description,
      reward_exp: reward_exp,
      reward_gold: reward_gold,
      created_at: created_at
    }
  end
end

class NPC < ActiveRecord::Base
  self.table_name = 'npcs'

  belongs_to :character
  has_many :relationships, foreign_key: 'npc_id', dependent: :destroy

  validates :character_id, :name, :role, presence: true

  def to_api_hash
    {
      id: id,
      name: name,
      role: role,
      description: description,
      race: race,
      faction: faction,
      status: status,
      first_met: first_met,
      personality_traits: personality_traits
    }
  end
end

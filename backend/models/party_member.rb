class PartyMember < ActiveRecord::Base
  self.table_name = 'party_members'

  belongs_to :character

  validates :character_id, :npc_name, :role, presence: true

  def to_api_hash
    {
      id: id,
      npc_name: npc_name,
      role: role,
      hp: hp,
      max_hp: max_hp,
      status: status,
      relationship_level: relationship_level
    }
  end
end

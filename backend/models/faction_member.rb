class FactionMember < ActiveRecord::Base
  self.table_name = 'faction_members'

  belongs_to :faction
  belongs_to :npc, optional: true

  validates :faction_id, :member_name, presence: true
end

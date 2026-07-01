class Faction < ActiveRecord::Base
  self.table_name = 'factions'

  belongs_to :character
  has_many :faction_members, dependent: :destroy

  validates :character_id, :name, :description, presence: true

  def to_api_hash
    {
      id: id,
      name: name,
      description: description,
      leader: leader,
      headquarters: headquarters,
      goals: goals,
      alignment: alignment,
      member_count: faction_members.count,
      discovered_at: discovered_at
    }
  end
end

class Relationship < ActiveRecord::Base
  self.table_name = 'relationships'

  belongs_to :character
  belongs_to :npc, class_name: 'NPC', foreign_key: 'npc_id'

  validates :character_id, :npc_id, presence: true

  # Relationship levels
  LEVELS = {
    despise: -100,
    hostile: -50,
    dislike: -20,
    neutral: 0,
    positive: 20,
    friendly: 50,
    adore: 100
  }.freeze

  def self.get_level_name(points)
    case points
    when -100...(-50) then 'Despise'
    when -50...(-20) then 'Hostile'
    when -20...0 then 'Dislike'
    when 0...20 then 'Neutral'
    when 20...50 then 'Positive'
    when 50...100 then 'Friendly'
    when 100.. then 'Adore'
    else 'Neutral'
    end
  end

  def level_name
    self.class.get_level_name(points)
  end

  def to_api_hash
    {
      id: id,
      npc_id: npc_id,
      npc_name: npc.name,
      points: points,
      level_name: level_name,
      notes: notes,
      first_met_at: first_met_at,
      last_interaction: last_interaction
    }
  end
end

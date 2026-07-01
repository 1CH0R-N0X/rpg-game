class StoryEvent < ActiveRecord::Base
  self.table_name = 'story_events'

  belongs_to :character

  validates :character_id, :event_type, :description, presence: true

  EVENT_TYPES = ['encounter', 'combat', 'dialogue', 'discovery', 'quest', 'relationship_change', 'faction_event', 'system'].freeze

  def to_api_hash
    {
      id: id,
      event_type: event_type,
      description: description,
      timestamp: created_at,
      npc_involved: npc_involved,
      faction_involved: faction_involved
    }
  end
end

class Location < ActiveRecord::Base
  self.table_name = 'locations'

  belongs_to :character

  validates :character_id, :name, :description, presence: true

  LOCATION_TYPES = ['tavern', 'dungeon', 'forest', 'village', 'ruin', 'cave', 'tower', 'shrine'].freeze

  def to_api_hash
    {
      id: id,
      name: name,
      description: description,
      location_type: location_type,
      danger_level: danger_level,
      visited_count: visited_count,
      discovered_at: discovered_at
    }
  end
end

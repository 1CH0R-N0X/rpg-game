class BestiaryController
  def self.get_all(character_id)
    begin
      entries = BestiaryEntry.where(character_id: character_id).map(&:to_api_hash)
      [200, { 'Content-Type' => 'application/json' }, { success: true, bestiary: entries }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.add_entry(character_id, params)
    begin
      data = JSON.parse(params)
      
      # Check if entry already exists
      entry = BestiaryEntry.find_by(character_id: character_id, creature_name: data['creature_name'])
      
      if entry
        entry.encounters_count += 1
        entry.defeated_count += 1 if data['defeated']
        entry.save
      else
        entry = BestiaryEntry.create(
          character_id: character_id,
          creature_name: data['creature_name'],
          creature_type: data['creature_type'] || 'Other',
          description: data['description'],
          hp: data['hp'],
          threat_level: data['threat_level'] || 'Medium',
          encounters_count: 1,
          defeated_count: data['defeated'] ? 1 : 0
        )
      end
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, entry: entry.to_api_hash }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end
end

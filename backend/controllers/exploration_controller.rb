class ExplorationController
  def self.explore(character_id)
    begin
      character = Character.find(character_id)
      
      # Generate/find location
      location = ExplorationEngine.generate_location(character)
      location.update(visited_count: location.visited_count + 1)
      
      # Maybe discover a new faction
      if rand > 0.7
        ExplorationEngine.discover_faction(character)
      end
      
      # Generate encounter
      encounter = ExplorationEngine.generate_encounter(character, location)
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, location: location.to_api_hash, encounter: encounter.to_api_hash }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.get_encounters(character_id, limit = 10)
    begin
      encounters = Encounter.where(character_id: character_id)
        .order(created_at: :desc)
        .limit(limit)
        .map(&:to_api_hash)
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, encounters: encounters }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end
end

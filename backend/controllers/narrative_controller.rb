class NarrativeController
  def self.generate_encounter(character_id, location)
    begin
      character = Character.find(character_id)
      description = NarrativeEngine.generate_encounter_description(character, location)
      
      StoryEvent.create(
        character_id: character_id,
        event_type: 'encounter',
        description: description
      )
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, description: description }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.generate_npc_dialogue(character_id, npc_id)
    begin
      npc = NPC.find(npc_id)
      relationship = Relationship.find_by(character_id: character_id, npc_id: npc_id)
      rel_points = relationship ? relationship.points : 0
      
      dialogue = NarrativeEngine.generate_npc_dialogue(npc, nil, rel_points)
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, dialogue: dialogue }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.get_story_log(character_id, limit = 20)
    begin
      events = StoryEvent.where(character_id: character_id)
        .order(created_at: :desc)
        .limit(limit)
        .map(&:to_api_hash)
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, events: events }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end
end

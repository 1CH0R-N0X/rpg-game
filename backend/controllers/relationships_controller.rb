class RelationshipsController
  def self.get_all(character_id)
    begin
      character = Character.find(character_id)
      
      # Create relationships for all NPCs if they don't exist
      NPC.where(character_id: character_id).each do |npc|
        unless Relationship.find_by(character_id: character_id, npc_id: npc.id)
          Relationship.create(
            character_id: character_id,
            npc_id: npc.id,
            points: 0,
            notes: 'Recently met',
            first_met_at: Time.now
          )
        end
      end
      
      relationships = Relationship.where(character_id: character_id).map(&:to_api_hash)
      [200, { 'Content-Type' => 'application/json' }, { success: true, relationships: relationships }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.update_relationship(character_id, npc_id, point_change, context = '')
    begin
      relationship = Relationship.find_by(character_id: character_id, npc_id: npc_id)
      
      unless relationship
        npc = NPC.find(npc_id)
        relationship = Relationship.create(
          character_id: character_id,
          npc_id: npc_id,
          points: 0,
          first_met_at: Time.now
        )
      end
      
      relationship.points += point_change
      relationship.last_interaction = Time.now
      relationship.notes = "#{context} (#{point_change > 0 ? '+' : ''}#{point_change})"
      relationship.save
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, relationship: relationship.to_api_hash }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end
end

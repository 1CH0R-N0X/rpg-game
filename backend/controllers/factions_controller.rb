class FactionsController
  def self.get_all(character_id)
    begin
      factions = Faction.where(character_id: character_id).map(&:to_api_hash)
      content_type :json
      { success: true, factions: factions }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.create(character_id, params)
    begin
      data = JSON.parse(params)
      
      faction = Faction.create(
        character_id: character_id,
        name: data['name'],
        description: data['description'],
        leader: data['leader'],
        headquarters: data['headquarters'],
        goals: data['goals'],
        alignment: data['alignment'] || 'Neutral'
      )
      
      content_type :json
      { success: true, faction: faction.to_api_hash }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.add_member(faction_id, member_name, npc_id = nil)
    begin
      member = FactionMember.create(
        faction_id: faction_id,
        member_name: member_name,
        npc_id: npc_id
      )
      
      content_type :json
      { success: true, member: member }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end
end

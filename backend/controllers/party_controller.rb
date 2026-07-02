class PartyController
  def self.add_npc(character_id, params)
    begin
      data = JSON.parse(params)
      character = Character.find(character_id)
      
      npc = PartyMember.create(
        character_id: character.id,
        npc_name: data['npc_name'],
        role: data['role'],
        hp: data['hp'] || 15,
        max_hp: data['hp'] || 15,
        status: 'healthy',
        relationship_level: 0
      )
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, party_member: npc.to_api_hash }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.get(character_id)
    begin
      character = Character.find(character_id)
      party = character.party_members.map(&:to_api_hash)
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, party: party }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end
end

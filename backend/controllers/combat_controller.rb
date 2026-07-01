class CombatController
  def self.start(params)
    begin
      data = JSON.parse(params)
      character = Character.find(data['character_id'])
      
      combat = CombatState.create(
        character_id: character.id,
        current_turn: 0,
        round: 1,
        status: 'active'
      )
      
      # Add player to combat
      player_init = CombatEngine.roll_initiative(character.dexterity)
      CombatParticipant.create(
        combat_state_id: combat.id,
        participant_name: character.name,
        is_player: true,
        hp: character.hp,
        max_hp: character.max_hp,
        initiative: player_init[:total],
        status: 'healthy'
      )
      
      # Add enemies
      data['enemies'].each do |enemy|
        enemy_init = CombatEngine.roll_initiative(enemy['dexterity'])
        CombatParticipant.create(
          combat_state_id: combat.id,
          participant_name: enemy['name'],
          is_player: false,
          hp: enemy['hp'],
          max_hp: enemy['hp'],
          initiative: enemy_init[:total],
          status: 'healthy'
        )
      end
      
      content_type :json
      { success: true, combat: combat.to_api_hash }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.take_action(combat_id, params)
    begin
      data = JSON.parse(params)
      combat = CombatState.find(combat_id)
      
      # Process action based on type
      case data['action_type']
      when 'attack'
        attack_result = CombatEngine.attack_roll(data['attack_bonus'])
        # Update HP based on hit
      when 'skill'
        # Handle skill check in combat
      end
      
      content_type :json
      { success: true, combat: combat.to_api_hash, action_result: data }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.get_state(combat_id)
    begin
      combat = CombatState.find(combat_id)
      content_type :json
      { success: true, combat: combat.to_api_hash }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end
end

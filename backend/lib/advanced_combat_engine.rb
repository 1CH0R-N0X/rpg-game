class AdvancedCombatEngine
  def self.generate_enemy_for_combat(combat_id)
    combat = CombatState.find(combat_id)
    enemy_template = ExplorationEngine::ENEMY_TEMPLATES.sample

    enemy_init = CombatEngine.roll_initiative(enemy_template[:dex])
    CombatParticipant.create!(
      combat_state_id: combat.id,
      participant_name: enemy_template[:name],
      is_player: false,
      hp: enemy_template[:hp],
      max_hp: enemy_template[:hp],
      initiative: enemy_init[:total],
      status: 'healthy'
    )
  end

  def self.enemy_takes_turn(combat_id, enemy_participant_id)
    combat = CombatState.find(combat_id)
    enemy = CombatParticipant.find(enemy_participant_id)
    player = combat.combat_participants.find { |p| p.is_player }

    # Random action
    action = rand > 0.3 ? 'attack' : 'defend'

    if action == 'attack'
      attack_roll = CombatEngine.attack_roll(3) # Base attack bonus
      
      if attack_roll[:is_critical_hit]
        damage = CombatEngine.damage_roll('d8', 2)
        narration = "#{enemy.participant_name} lands a DEVASTATING blow!"
      elsif attack_roll[:is_critical_miss]
        damage = { roll: [0], total: 0 }
        narration = "#{enemy.participant_name} misses completely!"
      elsif attack_roll[:total] > 10
        damage = CombatEngine.damage_roll('d6', 1)
        narration = "#{enemy.participant_name} hits you!"
      else
        damage = { roll: [0], total: 0 }
        narration = "You dodge #{enemy.participant_name}'s attack!"
      end

      player.update(hp: [player.hp - damage[:total], 0].max)
    else
      narration = "#{enemy.participant_name} takes a defensive stance!"
    end

    narration
  end

  def self.resolve_combat_victory(character_id, combat_id, enemy_names)
    character = Character.find(character_id)
    total_exp = 100
    total_gold = 50

    # Add bestiary entries and update them
    enemy_names.each do |enemy_name|
      entry = BestiaryEntry.find_or_create_by(
        character_id: character_id,
        creature_name: enemy_name
      )
      entry.defeated_count ||= 0
      entry.defeated_count += 1
      entry.save
    end

    # Grant rewards
    new_exp = character.exp + total_exp
    new_gold = character.coins + total_gold

    character.update(
      exp: new_exp,
      coins: new_gold
    )

    # Check for level up
    new_level = (new_exp / 100) + 1
    if new_level > character.level
      character.update(
        level: new_level,
        hp: character.max_hp,
        max_hp: character.max_hp + 5 # Increase max HP on level up
      )
    end

    StoryEvent.create!(
      character_id: character_id,
      event_type: 'combat',
      description: "Victory! You defeated #{enemy_names.join(', ')} and gained #{total_exp} experience and #{total_gold} gold."
    )

    {
      exp_gained: total_exp,
      gold_gained: total_gold,
      level_up: new_level > character.level,
      new_level: new_level
    }
  end
end

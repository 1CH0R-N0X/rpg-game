class ExplorationEngine
  LOCATIONS = [
    { name: 'The Rusty Tavern', type: 'tavern', danger: 'Low', description: 'A weathered old tavern filled with locals and travelers.' },
    { name: 'Shadow Forest', type: 'forest', danger: 'Medium', description: 'A dark forest where strange creatures lurk.' },
    { name: 'The Sunken Crypt', type: 'dungeon', danger: 'High', description: 'An ancient burial ground filled with undead guardians.' },
    { name: 'Farmer\'s Village', type: 'village', danger: 'Low', description: 'A peaceful village on the edge of civilization.' },
    { name: 'Crystal Cave', type: 'cave', danger: 'Medium', description: 'A cave system glimmering with mysterious crystals.' },
    { name: 'Crumbling Ruins', type: 'ruin', danger: 'Medium', description: 'Ancient ruins of a forgotten civilization.' },
    { name: 'The Obsidian Tower', type: 'tower', danger: 'High', description: 'A dark tower rumored to hold powerful artifacts.' },
    { name: 'Moonlit Shrine', type: 'shrine', danger: 'Medium', description: 'An old shrine dedicated to forgotten gods.' },
  ].freeze

  ENEMY_TEMPLATES = [
    { name: 'Goblin', type: 'Humanoid', hp: 7, attack: 2, defense: 1, dex: 8, threat: 'Low', gold: 5, exp: 50 },
    { name: 'Orc Warrior', type: 'Humanoid', hp: 15, attack: 4, defense: 2, dex: 10, threat: 'Medium', gold: 25, exp: 150 },
    { name: 'Skeleton', type: 'Undead', hp: 10, attack: 3, defense: 1, dex: 11, threat: 'Medium', gold: 15, exp: 100 },
    { name: 'Zombie', type: 'Undead', hp: 18, attack: 2, defense: 1, dex: 6, threat: 'Medium', gold: 10, exp: 80 },
    { name: 'Giant Wolf', type: 'Beast', hp: 12, attack: 4, defense: 1, dex: 13, threat: 'Medium', gold: 20, exp: 120 },
    { name: 'Dire Bear', type: 'Beast', hp: 25, attack: 5, defense: 3, dex: 10, threat: 'High', gold: 50, exp: 300 },
    { name: 'Dark Knight', type: 'Humanoid', hp: 30, attack: 6, defense: 4, dex: 12, threat: 'High', gold: 100, exp: 500 },
    { name: 'Bandit', type: 'Humanoid', hp: 10, attack: 3, defense: 1, dex: 14, threat: 'Low', gold: 30, exp: 75 },
  ].freeze

  NPC_TEMPLATES = [
    { name: 'Aldric', role: 'Warrior', personality: ['brave', 'loyal', 'gruff'] },
    { name: 'Elara', role: 'Mage', personality: ['wise', 'mysterious', 'cautious'] },
    { name: 'Kael', role: 'Rogue', personality: ['clever', 'cunning', 'witty'] },
    { name: 'Lyra', role: 'Cleric', personality: ['compassionate', 'faithful', 'determined'] },
    { name: 'Thorne', role: 'Ranger', personality: ['silent', 'skilled', 'independent'] },
    { name: 'Bram', role: 'Paladin', personality: ['righteous', 'strong', 'principled'] },
    { name: 'Silas', role: 'Bard', personality: ['charming', 'talkative', 'adventurous'] },
    { name: 'Mira', role: 'Druid', personality: ['peaceful', 'spiritual', 'protective'] },
  ].freeze

  FACTION_TEMPLATES = [
    { name: 'The Silver Guard', leader: 'Lord Commander Aldric', alignment: 'Lawful Good', goals: 'Protect the realm from darkness' },
    { name: 'The Shadow Syndicate', leader: 'Unknown', alignment: 'Chaotic Neutral', goals: 'Profit and power' },
    { name: 'The Druid Circle', leader: 'Elder Mara', alignment: 'Neutral', goals: 'Preserve nature and balance' },
    { name: 'The Dark Cult', leader: 'The Void Prophet', alignment: 'Chaotic Evil', goals: 'Summon eldritch horrors' },
    { name: 'The Merchant\'s Guild', leader: 'Master Corvus', alignment: 'Lawful Neutral', goals: 'Trade and commerce' },
  ].freeze

  def self.generate_location(character)
    loc_template = LOCATIONS.sample
    Location.find_or_create_by(
      character_id: character.id,
      name: loc_template[:name]
    ) do |loc|
      loc.description = loc_template[:description]
      loc.location_type = loc_template[:type]
      loc.danger_level = loc_template[:danger]
      loc.visited_count = 0
    end
  end

  def self.generate_encounter(character, location)
    encounter_type = ['npc', 'combat', 'discovery'].sample
    description = ""

    case encounter_type
    when 'npc'
      npc_template = NPC_TEMPLATES.sample
      npc = NPC.create!(
        character_id: character.id,
        name: npc_template[:name],
        role: npc_template[:role],
        description: "A #{npc_template[:role].downcase} with a mysterious past.",
        race: ['Human', 'Elf', 'Dwarf', 'Halfling', 'Half-Orc'].sample,
        personality_traits: npc_template[:personality].join(', '),
        first_met: Time.now
      )

      # Create relationship
      Relationship.create!(
        character_id: character.id,
        npc_id: npc.id,
        points: 0,
        notes: 'Recently met',
        first_met_at: Time.now
      )

      # Maybe add to a faction
      if rand > 0.5
        faction = Faction.where(character_id: character.id).sample
        if faction
          npc.update(faction: faction.name)
          FactionMember.create!(faction_id: faction.id, member_name: npc.name, npc_id: npc.id)
        end
      end

      description = "You encounter #{npc.name}, a #{npc.role}. They seem #{npc_template[:personality].first}."
      reward_exp = 25
      reward_gold = 0

    when 'combat'
      enemy_template = ENEMY_TEMPLATES.sample
      description = "A #{enemy_template[:name]} appears! You must fight!"
      reward_exp = enemy_template[:exp]
      reward_gold = enemy_template[:gold]

      # Add to bestiary
      BestiaryEntry.find_or_create_by(
        character_id: character.id,
        creature_name: enemy_template[:name]
      ) do |entry|
        entry.creature_type = enemy_template[:type]
        entry.hp = enemy_template[:hp]
        entry.threat_level = enemy_template[:threat]
        entry.encounters_count = 1
        entry.discovered_at = Time.now
      end

    when 'discovery'
      discoveries = [
        'You find an ancient tome with mysterious writings.',
        'A hidden chest filled with gold and jewels!',
        'An old shrine dedicated to a forgotten god.',
        'A map pointing to legendary treasures.',
        'Remnants of a great battle from ages past.'
      ]
      description = discoveries.sample
      reward_exp = 50
      reward_gold = 20
    end

    encounter = Encounter.create!(
      character_id: character.id,
      location_id: location.id,
      encounter_type: encounter_type,
      description: description,
      reward_exp: reward_exp,
      reward_gold: reward_gold
    )

    # Log story event
    StoryEvent.create!(
      character_id: character.id,
      event_type: 'encounter',
      description: description
    )

    encounter
  end

  def self.discover_faction(character)
    # Don't create duplicate factions
    existing_count = Faction.where(character_id: character.id).count
    return if existing_count >= 3 # Max 3 factions for now

    faction_template = FACTION_TEMPLATES.sample
    faction = Faction.create!(
      character_id: character.id,
      name: faction_template[:name],
      description: "An organization with unclear motives.",
      leader: faction_template[:leader],
      headquarters: ["Tavern", "Tower", "Underground Base", "Forest Sanctuary"].sample,
      goals: faction_template[:goals],
      alignment: faction_template[:alignment],
      discovered_at: Time.now
    )

    # Create initial reputation (neutral)
    Reputation.create!(
      character_id: character.id,
      faction_id: faction.id,
      points: 0
    )

    faction
  end
end

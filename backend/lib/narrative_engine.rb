require 'natural_20'
require 'openai' # Will add to Gemfile

class NarrativeEngine
  # Simulated AI responses - replace with actual API calls to OpenAI
  def self.generate_encounter_description(character, location)
    descriptions = [
      "You enter #{location}. A strange atmosphere fills the air.",
      "The wind carries whispers as you approach #{location}.",
      "You find yourself in #{location}. Something feels off.",
      "#{location} looms before you, shrouded in mystery."
    ]
    descriptions.sample
  end

  def self.generate_npc_dialogue(npc, character, relationship_points)
    case relationship_points
    when -100...(-50)
      "#{npc.name} glares at you with pure hatred."
    when -50...(-20)
      "#{npc.name} turns away, clearly displeased to see you."
    when -20...0
      "#{npc.name} nods coolly, maintaining distance."
    when 0...20
      "#{npc.name} greets you with a neutral expression."
    when 20...50
      "#{npc.name} smiles warmly at your arrival."
    when 50...100
      "#{npc.name} rushes toward you with genuine joy."
    when 100..
      "#{npc.name} embraces you like an old friend. 'I was hoping to see you!'"
    else
      "#{npc.name} looks at you."
    end
  end

  def self.generate_combat_narration(attacker, defender, roll_result)
    if roll_result[:is_critical_hit]
      "#{attacker.name} lands a DEVASTATING blow on #{defender.name}!"
    elsif roll_result[:is_critical_miss]
      "#{attacker.name} stumbles and misses completely!"
    elsif roll_result[:total] > 15
      "#{attacker.name} strikes #{defender.name} with precision!"
    elsif roll_result[:total] < 5
      "#{defender.name} easily dodges #{attacker.name}'s attack."
    else
      "#{attacker.name} lands a solid hit on #{defender.name}."
    end
  end

  def self.generate_quest_hook(character, npc, faction = nil)
    verbs = ['investigate', 'retrieve', 'protect', 'eliminate', 'rescue', 'discover']
    objects = ['the lost artifact', 'the missing person', 'the hidden lair', 'the ancient tome', 'the stolen goods']
    
    "#{npc.name} asks you to #{verbs.sample} #{objects.sample}."
  end

  def self.generate_faction_event(faction, event_type)
    case event_type
    when 'conflict'
      "Internal tensions within #{faction.name} are rising."
    when 'expansion'
      "#{faction.name} has established a new base of operations."
    when 'discovery'
      "#{faction.name} has made a shocking discovery."
    when 'betrayal'
      "A traitor has been discovered within #{faction.name}."
    else
      "Something significant has occurred within #{faction.name}."
    end
  end

  def self.generate_loot_description(rarity)
    case rarity
    when 'common'
      'a mundane item of little value'
    when 'uncommon'
      'an interesting item worth a bit'
    when 'rare'
      'a valuable and unusual artifact'
    when 'legendary'
      'a magnificent treasure of great power'
    else
      'something'
    end
  end
end

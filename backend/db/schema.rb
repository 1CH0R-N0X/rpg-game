ActiveRecord::Schema.define(version: 3) do
  create_table :characters, force: :cascade do |t|
    t.string :name, null: false
    t.string :race, null: false
    t.string :character_class, null: false
    t.integer :level, default: 1
    t.integer :exp, default: 0
    t.integer :hp, default: 20
    t.integer :max_hp, default: 20
    t.integer :coins, default: 0
    t.integer :constitution, default: 10
    t.integer :wisdom, default: 10
    t.integer :charisma, default: 10
    t.integer :strength, default: 10
    t.integer :intellect, default: 10
    t.integer :dexterity, default: 10
    t.text :backstory
    t.timestamps
  end

  create_table :inventory_items, force: :cascade do |t|
    t.integer :character_id, null: false
    t.string :item_name, null: false
    t.integer :quantity, default: 1
    t.string :item_type, default: 'misc'
    t.string :rarity, default: 'common'
    t.timestamps
    t.foreign_key :characters
  end

  create_table :party_members, force: :cascade do |t|
    t.integer :character_id, null: false
    t.string :npc_name, null: false
    t.string :role, null: false
    t.integer :hp, default: 15
    t.integer :max_hp, default: 15
    t.string :status, default: 'healthy'
    t.integer :relationship_level, default: 0
    t.timestamps
    t.foreign_key :characters
  end

  create_table :combat_states, force: :cascade do |t|
    t.integer :character_id, null: false
    t.integer :current_turn, default: 0
    t.integer :round, default: 1
    t.string :status, default: 'active'
    t.timestamps
    t.foreign_key :characters
  end

  create_table :combat_participants, force: :cascade do |t|
    t.integer :combat_state_id, null: false
    t.string :participant_name, null: false
    t.boolean :is_player, default: false
    t.integer :hp, default: 10
    t.integer :max_hp, default: 10
    t.integer :initiative, default: 0
    t.string :status, default: 'healthy'
    t.timestamps
    t.foreign_key :combat_states
  end

  create_table :npcs, force: :cascade do |t|
    t.integer :character_id, null: false
    t.string :name, null: false
    t.string :role, null: false
    t.text :description
    t.string :race
    t.string :faction
    t.string :status, default: 'active'
    t.datetime :first_met
    t.text :personality_traits
    t.timestamps
    t.foreign_key :characters
  end

  create_table :relationships, force: :cascade do |t|
    t.integer :character_id, null: false
    t.integer :npc_id, null: false
    t.integer :points, default: 0
    t.text :notes
    t.datetime :first_met_at
    t.datetime :last_interaction
    t.timestamps
    t.foreign_key :characters
    t.foreign_key :npcs
  end

  create_table :bestiary_entries, force: :cascade do |t|
    t.integer :character_id, null: false
    t.string :creature_name, null: false
    t.string :creature_type, default: 'Other'
    t.text :description
    t.integer :hp, default: 10
    t.string :threat_level, default: 'Medium'
    t.integer :encounters_count, default: 0
    t.integer :defeated_count, default: 0
    t.datetime :discovered_at
    t.timestamps
    t.foreign_key :characters
  end

  create_table :factions, force: :cascade do |t|
    t.integer :character_id, null: false
    t.string :name, null: false
    t.text :description
    t.string :leader
    t.string :headquarters
    t.text :goals
    t.string :alignment, default: 'Neutral'
    t.datetime :discovered_at
    t.timestamps
    t.foreign_key :characters
  end

  create_table :faction_members, force: :cascade do |t|
    t.integer :faction_id, null: false
    t.string :member_name, null: false
    t.integer :npc_id
    t.timestamps
    t.foreign_key :factions
  end

  create_table :reputations, force: :cascade do |t|
    t.integer :character_id, null: false
    t.integer :faction_id, null: false
    t.integer :points, default: 0
    t.timestamps
    t.foreign_key :characters
    t.foreign_key :factions
  end

  create_table :story_events, force: :cascade do |t|
    t.integer :character_id, null: false
    t.string :event_type, null: false
    t.text :description, null: false
    t.string :npc_involved
    t.string :faction_involved
    t.timestamps
    t.foreign_key :characters
  end

  create_table :quests, force: :cascade do |t|
    t.integer :character_id, null: false
    t.integer :npc_id
    t.string :title, null: false
    t.text :description
    t.string :quest_type, default: 'generic'
    t.string :status, default: 'active'
    t.integer :reward_exp, default: 0
    t.integer :reward_gold, default: 0
    t.datetime :completed_at
    t.timestamps
    t.foreign_key :characters
  end

  create_table :locations, force: :cascade do |t|
    t.integer :character_id, null: false
    t.string :name, null: false
    t.text :description
    t.string :location_type, default: 'dungeon'
    t.string :danger_level, default: 'Medium'
    t.integer :visited_count, default: 0
    t.datetime :discovered_at
    t.timestamps
    t.foreign_key :characters
  end

  create_table :encounters, force: :cascade do |t|
    t.integer :character_id, null: false
    t.integer :location_id
    t.string :encounter_type, null: false
    t.text :description
    t.integer :reward_exp, default: 0
    t.integer :reward_gold, default: 0
    t.timestamps
    t.foreign_key :characters
    t.foreign_key :locations
  end

  create_table :enemies, force: :cascade do |t|
    t.string :name, null: false
    t.string :enemy_type, default: 'Generic'
    t.integer :hp, default: 10
    t.integer :attack_bonus, default: 2
    t.integer :defense, default: 1
    t.integer :dexterity, default: 10
    t.string :threat_level, default: 'Medium'
    t.integer :loot_gold, default: 0
    t.integer :experience_reward, default: 0
    t.timestamps
  end
end

ActiveRecord::Schema.define(version: 1) do
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
end

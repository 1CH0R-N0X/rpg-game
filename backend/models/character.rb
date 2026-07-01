class Character < ActiveRecord::Base
  self.table_name = 'characters'

  has_many :inventory_items, dependent: :destroy
  has_many :party_members, dependent: :destroy
  has_many :combat_participants, dependent: :destroy

  validates :name, :race, :character_class, presence: true

  def self.create_from_params(params)
    char_params = JSON.parse(params) rescue params

    character = new(
      name: char_params['name'],
      race: char_params['race'],
      character_class: char_params['class'],
      level: 1,
      exp: 0,
      hp: char_params['hp'] || 20,
      max_hp: char_params['hp'] || 20,
      coins: 25,
      constitution: char_params['stats']['Constitution'],
      wisdom: char_params['stats']['Wisdom'],
      charisma: char_params['stats']['Charisma'],
      strength: char_params['stats']['Strength'],
      intellect: char_params['stats']['Intellect'],
      dexterity: char_params['stats']['Dexterity'],
      backstory: char_params['backstory'] || ''
    )

    character.save
    character
  end

  def to_api_hash
    {
      id: id,
      name: name,
      race: race,
      class: character_class,
      level: level,
      exp: exp,
      hp: hp,
      max_hp: max_hp,
      coins: coins,
      stats: {
        Constitution: constitution,
        Wisdom: wisdom,
        Charisma: charisma,
        Strength: strength,
        Intellect: intellect,
        Dexterity: dexterity
      },
      backstory: backstory,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end

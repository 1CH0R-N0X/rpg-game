class Enemy < ActiveRecord::Base
  self.table_name = 'enemies'

  validates :name, :enemy_type, presence: true

  def to_api_hash
    {
      id: id,
      name: name,
      enemy_type: enemy_type,
      hp: hp,
      attack_bonus: attack_bonus,
      defense: defense,
      dexterity: dexterity,
      threat_level: threat_level,
      loot_gold: loot_gold,
      experience_reward: experience_reward
    }
  end
end

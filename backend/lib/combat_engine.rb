class CombatEngine
  def self.roll_initiative(dexterity)
    roller = Natural20::Roller.new
    roll = roller.roll('d20')
    modifier = (dexterity - 10) / 2
    total = roll.values.first + modifier
    { roll: roll.values.first, modifier: modifier, total: total }
  end

  def self.attack_roll(attack_bonus)
    roller = Natural20::Roller.new
    roll = roller.roll('d20')
    total = roll.values.first + attack_bonus
    
    {
      roll: roll.values.first,
      attack_bonus: attack_bonus,
      total: total,
      is_critical_hit: roll.values.first == 20,
      is_critical_miss: roll.values.first == 1
    }
  end

  def self.damage_roll(weapon_damage_dice, modifier)
    roller = Natural20::Roller.new
    roll = roller.roll(weapon_damage_dice)
    total = roll.sum + modifier
    { roll: roll.values, total: total }
  end

  def self.sort_by_initiative(participants)
    participants.sort_by { |p| -p[:initiative] }
  end
end

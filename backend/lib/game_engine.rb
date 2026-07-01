require 'natural_20'

class GameEngine
  def self.roll_skill_check(stat_value)
    roller = Natural20::Roller.new
    roll = roller.roll('d20')
    total = roll.sum + stat_value

    {
      roll: roll.values.first,
      stat_bonus: stat_value,
      total: total,
      success: total >= 10
    }
  end

  def self.get_modifier(stat)
    (stat - 10) / 2
  end

  def self.calculate_hp(constitution, character_class)
    base_hp = case character_class.downcase
              when 'enforcer' then 12
              when 'drifter' then 10
              when 'scavenger' then 8
              else 10
              end

    con_mod = get_modifier(constitution)
    [base_hp + con_mod, 1].max
  end

  def self.grant_exp(current_exp, amount)
    current_exp + amount
  end

  def self.check_levelup(exp)
    new_level = (exp / 100) + 1
    { level: new_level, level_up: true }
  end
end

class CombatState < ActiveRecord::Base
  self.table_name = 'combat_states'

  belongs_to :character
  has_many :combat_participants, dependent: :destroy

  validates :character_id, presence: true

  def to_api_hash
    {
      id: id,
      character_id: character_id,
      current_turn: current_turn,
      round: round,
      status: status,
      participants: combat_participants.map(&:to_api_hash)
    }
  end
end

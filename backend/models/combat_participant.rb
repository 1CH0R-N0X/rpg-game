class CombatParticipant < ActiveRecord::Base
  self.table_name = 'combat_participants'

  belongs_to :combat_state

  validates :combat_state_id, :participant_name, :is_player, presence: true

  def to_api_hash
    {
      id: id,
      participant_name: participant_name,
      is_player: is_player,
      hp: hp,
      max_hp: max_hp,
      initiative: initiative,
      status: status
    }
  end
end

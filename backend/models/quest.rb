class Quest < ActiveRecord::Base
  self.table_name = 'quests'

  belongs_to :character
  belongs_to :npc, optional: true

  validates :character_id, :title, :description, presence: true

  STATUSES = ['active', 'completed', 'failed', 'abandoned'].freeze

  def to_api_hash
    {
      id: id,
      title: title,
      description: description,
      quest_type: quest_type,
      npc_name: npc&.name,
      status: status,
      reward_exp: reward_exp,
      reward_gold: reward_gold,
      created_at: created_at,
      completed_at: completed_at
    }
  end
end

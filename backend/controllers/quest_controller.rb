class QuestController
  def self.get_all(character_id)
    begin
      quests = Quest.where(character_id: character_id).map(&:to_api_hash)
      [200, { 'Content-Type' => 'application/json' }, { success: true, quests: quests }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.create_from_npc(character_id, npc_id)
    begin
      quest = QuestEngine.generate_quest_for_npc(character_id, npc_id)
      [200, { 'Content-Type' => 'application/json' }, { success: true, quest: quest.to_api_hash }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.complete(character_id, quest_id)
    begin
      result = QuestEngine.complete_quest(character_id, quest_id)
      [200, { 'Content-Type' => 'application/json' }, { success: result[:success], data: result }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end
end

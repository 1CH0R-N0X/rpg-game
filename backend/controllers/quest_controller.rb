class QuestController
  def self.get_all(character_id)
    begin
      quests = Quest.where(character_id: character_id).map(&:to_api_hash)
      content_type :json
      { success: true, quests: quests }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.create_from_npc(character_id, npc_id)
    begin
      quest = QuestEngine.generate_quest_for_npc(character_id, npc_id)
      content_type :json
      { success: true, quest: quest.to_api_hash }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.complete(character_id, quest_id)
    begin
      result = QuestEngine.complete_quest(character_id, quest_id)
      content_type :json
      { success: result[:success], data: result }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end
end

class ReputationController
  def self.get_all(character_id)
    begin
      reputations = Reputation.where(character_id: character_id).map(&:to_api_hash)
      content_type :json
      { success: true, reputations: reputations }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.update(character_id, faction_id, point_change)
    begin
      reputation = Reputation.find_by(character_id: character_id, faction_id: faction_id)
      
      unless reputation
        reputation = Reputation.create(
          character_id: character_id,
          faction_id: faction_id,
          points: 0
        )
      end
      
      reputation.points += point_change
      reputation.save
      
      content_type :json
      { success: true, reputation: reputation.to_api_hash }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end
end

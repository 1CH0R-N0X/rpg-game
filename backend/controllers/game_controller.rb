class GameController
  def self.skill_check(params)
    begin
      data = JSON.parse(params)
      character_id = data['character_id']
      stat_name = data['stat_name']
      
      character = Character.find(character_id)
      stat_value = character.send(stat_name.downcase)
      
      result = GameEngine.roll_skill_check(stat_value)
      
      content_type :json
      {
        success: true,
        character_id: character_id,
        skill: data['skill_name'],
        stat: stat_name,
        result: result
      }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end
end

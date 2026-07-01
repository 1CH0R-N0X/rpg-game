class CharacterController
  def self.create(params)
    begin
      character = Character.create_from_params(params)
      content_type :json
      { success: true, character: character.to_api_hash }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.get(id)
    begin
      character = Character.find(id)
      content_type :json
      { success: true, character: character.to_api_hash }.to_json
    rescue ActiveRecord::RecordNotFound
      status 404
      { success: false, error: 'Character not found' }.to_json
    end
  end

  def self.list
    begin
      characters = Character.all.map(&:to_api_hash)
      content_type :json
      { success: true, characters: characters }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.update(id, params)
    begin
      character = Character.find(id)
      update_params = JSON.parse(params) rescue params
      
      character.update(
        hp: update_params['hp'] || character.hp,
        exp: update_params['exp'] || character.exp,
        coins: update_params['coins'] || character.coins,
        level: update_params['level'] || character.level
      )
      
      content_type :json
      { success: true, character: character.to_api_hash }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end
end

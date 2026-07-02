class CharacterController
  def self.create(params)
    begin
      data = JSON.parse(params) rescue params
      require_relative '../lib/validation'
      ok, err = Validation.require_fields(data, 'name')
      unless ok
        return [400, { 'Content-Type' => 'application/json' }, { success: false, error: err }.to_json]
      end

      character = Character.create_from_params(params)
      [200, { 'Content-Type' => 'application/json' }, { success: true, character: character.to_api_hash }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end

  def self.get(id)
    begin
      character = Character.find(id)
      [200, { 'Content-Type' => 'application/json' }, { success: true, character: character.to_api_hash }.to_json]
    rescue ActiveRecord::RecordNotFound
      [404, { 'Content-Type' => 'application/json' }, { success: false, error: 'Character not found' }.to_json]
    end
  end

  def self.list
    begin
      characters = Character.all.map(&:to_api_hash)
      [200, { 'Content-Type' => 'application/json' }, { success: true, characters: characters }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
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
      
      [200, { 'Content-Type' => 'application/json' }, { success: true, character: character.to_api_hash }.to_json]
    rescue => e
      [400, { 'Content-Type' => 'application/json' }, { success: false, error: e.message }.to_json]
    end
  end
end

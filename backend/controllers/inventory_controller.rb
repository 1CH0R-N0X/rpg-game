class InventoryController
  def self.add_item(character_id, params)
    begin
      data = JSON.parse(params)
      character = Character.find(character_id)
      
      item = InventoryItem.create(
        character_id: character.id,
        item_name: data['item_name'],
        quantity: data['quantity'] || 1,
        item_type: data['item_type'] || 'misc',
        rarity: data['rarity'] || 'common'
      )
      
      content_type :json
      { success: true, item: item.to_api_hash }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end

  def self.get(character_id)
    begin
      character = Character.find(character_id)
      items = character.inventory_items.map(&:to_api_hash)
      
      content_type :json
      { success: true, inventory: items, coins: character.coins }.to_json
    rescue => e
      status 400
      { success: false, error: e.message }.to_json
    end
  end
end

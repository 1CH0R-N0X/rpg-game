class InventoryItem < ActiveRecord::Base
  self.table_name = 'inventory_items'

  belongs_to :character

  validates :character_id, :item_name, :quantity, presence: true

  def to_api_hash
    {
      id: id,
      item_name: item_name,
      quantity: quantity,
      item_type: item_type,
      rarity: rarity
    }
  end
end

// data.js
export const initialPlayer = {
  name: "Unnamed Hero",
  class: "Scavenger",
  level: 1,
  exp: 0,
  hp: 20,
  maxHp: 20,
  coins: 25,
  stats: {
    Constitution: 5, 
    Wisdom: 3, 
    Charisma: 6,
    Strength: 3, 
    Intellect: 3, 
    Dexterity: 7
  },
  skills: {
    Strength: ["Athletics"],
    Dexterity: ["Acrobatics", "Sleight of Hand", "Stealth"],
    Intellect: ["Arcana", "History", "Investigation", "Nature", "Religion"],
    Wisdom: ["Animal Handling", "Insight", "Medicine", "Perception", "Survival"],
    Charisma: ["Deception", "Intimidation", "Performance", "Persuasion"]
  },
  equipped: ["Rusty Dagger", "Traveler's Cloak"],
  inventory: {
    weapons: ["Rusty Dagger", "Hunting Bow"],
    apparel: ["Traveler's Cloak", "Leather Boots"],
    consumables: ["Health Tonic x3", "Dried Rations x5"],
    misc: ["Rusty Key", "Tattered Map"]
  }
};
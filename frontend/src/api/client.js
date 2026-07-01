const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:9292/api';

const request = async (endpoint, options = {}) => {
  const response = await fetch(`${API_URL}${endpoint}`, {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
    ...options,
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.status}`);
  }

  return response.json();
};

export const apiClient = {
  // Characters
  createCharacter: (characterData) =>
    request('/characters', {
      method: 'POST',
      body: JSON.stringify(characterData),
    }),

  getCharacter: (id) => request(`/characters/${id}`),
  listCharacters: () => request('/characters'),
  updateCharacter: (id, data) =>
    request(`/characters/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),

  // Skills
  rollSkillCheck: (characterId, skillName, statName) =>
    request('/skill-check', {
      method: 'POST',
      body: JSON.stringify({
        character_id: characterId,
        skill_name: skillName,
        stat_name: statName,
      }),
    }),

  // Combat
  startCombat: (characterId, enemies) =>
    request('/combat/start', {
      method: 'POST',
      body: JSON.stringify({
        character_id: characterId,
        enemies: enemies,
      }),
    }),

  getCombatState: (combatId) => request(`/combat/${combatId}`),

  takeCombatAction: (combatId, actionData) =>
    request(`/combat/${combatId}/action`, {
      method: 'POST',
      body: JSON.stringify(actionData),
    }),

  // Inventory
  getInventory: (characterId) => request(`/inventory/${characterId}`),
  addItem: (characterId, itemData) =>
    request(`/inventory/${characterId}/items`, {
      method: 'POST',
      body: JSON.stringify(itemData),
    }),

  // Party
  getParty: (characterId) => request(`/party/${characterId}`),
  addNPC: (characterId, npcData) =>
    request(`/party/${characterId}/add-npc`, {
      method: 'POST',
      body: JSON.stringify(npcData),
    }),
};

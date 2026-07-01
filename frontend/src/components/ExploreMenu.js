import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';

export default function ExploreMenu({ characterId, onBack, onEncounter, addLog }) {
  const [location, setLocation] = useState(null);
  const [encounter, setEncounter] = useState(null);
  const [loading, setLoading] = useState(false);
  const [history, setHistory] = useState([]);

  useEffect(() => {
    loadEncounterHistory();
  }, [characterId]);

  const loadEncounterHistory = async () => {
    try {
      const response = await apiClient.getEncounters(characterId);
      if (response.success) {
        setHistory(response.encounters || []);
      }
    } catch (err) {
      console.error('Failed to load history:', err);
    }
  };

  const handleExplore = async () => {
    setLoading(true);
    try {
      const response = await apiClient.explore(characterId);
      if (response.success) {
        setLocation(response.location);
        setEncounter(response.encounter);
        addLog(`You arrive at ${response.location.name}...`);
        addLog(response.encounter.description);
        loadEncounterHistory();
      }
    } catch (err) {
      addLog(`Error: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  if (encounter && location) {
    return (
      <div className="terminal-box">
        <h1>[LOCATION: {location.name.toUpperCase()}]</h1>
        <div style={{ border: '1px solid #333', padding: '15px', marginBottom: '20px' }}>
          <p style={{ color: '#999', marginBottom: '10px' }}>{location.description}</p>
          <p style={{ fontSize: '0.85em', color: '#666' }}>
            Danger: {location.danger_level} | Visited: {location.visited_count} times
          </p>
        </div>

        <h3>ENCOUNTER</h3>
        <div
          style={{
            border:
              encounter.encounter_type === 'combat'
                ? '1px solid #ff3333'
                : encounter.encounter_type === 'npc'
                ? '1px solid #33ff33'
                : '1px solid #ffff00',
            padding: '15px',
            marginBottom: '20px',
            background: '#0a0a0a',
          }}
        >
          <p style={{ fontStyle: 'italic' }}>{encounter.description}</p>
          <p style={{ fontSize: '0.85em', color: '#999', marginTop: '10px' }}>
            Type: {encounter.encounter_type} | Rewards: {encounter.reward_exp} EXP, {encounter.reward_gold} Gold
          </p>
        </div>

        <button className="term-button" onClick={() => setEncounter(null)}>
          CONTINUE EXPLORING
        </button>
        <button className="term-button" onClick={onBack}>
          RETURN TO TOWN
        </button>
      </div>
    );
  }

  return (
    <div className="terminal-box">
      <h1>[MENU: EXPLORE]</h1>
      <p style={{ color: '#999', marginBottom: '20px' }}>Venture forth and discover new locations and encounters</p>

      <button className="term-button" onClick={handleExplore} disabled={loading}>
        {loading ? 'EXPLORING...' : 'EXPLORE'}
      </button>

      {history.length > 0 && (
        <div style={{ marginTop: '30px' }}>
          <h3>RECENT ENCOUNTERS</h3>
          {history.slice(0, 5).map((enc) => (
            <div key={enc.id} style={{ border: '1px solid #333', padding: '10px', marginBottom: '10px', fontSize: '0.9em' }}>
              <p>{enc.description}</p>
              <p style={{ color: '#999', fontSize: '0.8em' }}>
                {new Date(enc.created_at).toLocaleDateString()}
              </p>
            </div>
          ))}
        </div>
      )}

      <button className="term-button" onClick={onBack} style={{ marginTop: '20px' }}>
        BACK
      </button>
    </div>
  );
}

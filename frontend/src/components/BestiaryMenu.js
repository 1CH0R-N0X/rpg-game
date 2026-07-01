import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';

export default function BestiaryMenu({ characterId, onBack }) {
  const [bestiary, setBestiary] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedCreature, setSelectedCreature] = useState(null);

  useEffect(() => {
    loadBestiary();
  }, [characterId]);

  const loadBestiary = async () => {
    try {
      const response = await apiClient.getBestiary(characterId);
      if (response.success) {
        setBestiary(response.bestiary || []);
      }
    } catch (err) {
      console.error('Failed to load bestiary:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="terminal-box">Loading bestiary...</div>;

  if (selectedCreature) {
    return (
      <div className="terminal-box">
        <h1>[BESTIARY: {selectedCreature.creature_name.toUpperCase()}]</h1>
        <div style={{ border: '1px solid #333', padding: '15px', marginBottom: '20px' }}>
          <p>
            <strong>Type:</strong> {selectedCreature.creature_type}
          </p>
          <p>
            <strong>Description:</strong> {selectedCreature.description || 'Unknown'}
          </p>
          <p>
            <strong>HP:</strong> {selectedCreature.hp}
          </p>
          <p>
            <strong>Threat Level:</strong>
            <span
              style={{
                marginLeft: '10px',
                color:
                  selectedCreature.threat_level === 'High'
                    ? '#ff0000'
                    : selectedCreature.threat_level === 'Medium'
                    ? '#ffff00'
                    : '#00ff00',
              }}
            >
              {selectedCreature.threat_level}
            </span>
          </p>
          <p>
            <strong>Encounters:</strong> {selectedCreature.encounters_count}
          </p>
          <p>
            <strong>Defeated:</strong> {selectedCreature.defeated_count}
          </p>
        </div>
        <button className="term-button" onClick={() => setSelectedCreature(null)}>
          BACK TO LIST
        </button>
      </div>
    );
  }

  return (
    <div className="terminal-box">
      <h1>[MENU: BESTIARY]</h1>
      <p style={{ color: '#999', marginBottom: '20px' }}>Creatures and beasts you've encountered</p>

      {bestiary.length === 0 ? (
        <p>No creatures discovered yet.</p>
      ) : (
        bestiary.map((creature) => (
          <div
            key={creature.id}
            onClick={() => setSelectedCreature(creature)}
            style={{
              border: '1px solid #333',
              padding: '10px',
              marginBottom: '10px',
              cursor: 'pointer',
              transition: 'all 0.2s',
            }}
            onMouseEnter={(e) => e.currentTarget.style.borderColor = '#d1d1d1'}
            onMouseLeave={(e) => e.currentTarget.style.borderColor = '#333'}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span style={{ fontWeight: 'bold' }}>{creature.creature_name}</span>
              <span
                style={{
                  fontSize: '0.9em',
                  color:
                    creature.threat_level === 'High'
                      ? '#ff0000'
                      : creature.threat_level === 'Medium'
                      ? '#ffff00'
                      : '#00ff00',
                }}
              >
                {creature.threat_level}
              </span>
            </div>
            <p style={{ fontSize: '0.8em', color: '#999', margin: '5px 0 0 0' }}>
              Type: {creature.creature_type} | Encountered: {creature.encounters_count} times
            </p>
          </div>
        ))
      )}

      <button className="term-button" onClick={onBack} style={{ marginTop: '20px' }}>
        BACK
      </button>
    </div>
  );
}

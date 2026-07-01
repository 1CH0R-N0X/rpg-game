import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';

const RelationshipMeter = ({ points }) => {
  let level, color;
  
  if (points <= -100) {
    level = 'DESPISE';
    color = '#8b0000';
  } else if (points <= -50) {
    level = 'HOSTILE';
    color = '#ff0000';
  } else if (points <= -20) {
    level = 'DISLIKE';
    color = '#ff6600';
  } else if (points < 20) {
    level = 'NEUTRAL';
    color = '#666666';
  } else if (points < 50) {
    level = 'POSITIVE';
    color = '#ffff00';
  } else if (points < 100) {
    level = 'FRIENDLY';
    color = '#00ff00';
  } else {
    level = 'ADORE';
    color = '#00ff99';
  }
  
  const percentage = Math.max(0, Math.min(100, (points + 100) / 2));
  
  return (
    <div style={{ marginBottom: '15px' }}>
      <div style={{
        display: 'flex',
        justifyContent: 'space-between',
        marginBottom: '5px',
        fontSize: '0.9em'
      }}>
        <span>DESPISE</span>
        <span style={{ fontWeight: 'bold', color }}>{level}</span>
        <span>ADORE</span>
      </div>
      <div style={{
        background: '#222',
        height: '12px',
        border: '1px solid #333',
        position: 'relative'
      }}>
        <div
          style={{
            background: color,
            height: '100%',
            width: `${percentage}%`,
            transition: 'all 0.3s ease'
          }}
        />
      </div>
      <p style={{ fontSize: '0.8em', color: '#999', margin: '5px 0 0 0' }}>
        Points: {points}
      </p>
    </div>
  );
};

export default function RelationsMenu({ characterId, onBack }) {
  const [relationships, setRelationships] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedNPC, setSelectedNPC] = useState(null);

  useEffect(() => {
    loadRelationships();
  }, [characterId]);

  const loadRelationships = async () => {
    try {
      const response = await apiClient.getRelationships(characterId);
      if (response.success) {
        setRelationships(response.relationships || []);
      }
    } catch (err) {
      console.error('Failed to load relationships:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="terminal-box">Loading relationships...</div>;

  if (selectedNPC) {
    return (
      <div className="terminal-box">
        <h1>[RELATIONS: {selectedNPC.npc_name.toUpperCase()}]</h1>
        <div style={{ border: '1px solid #333', padding: '15px', marginBottom: '20px' }}>
          <h2>{selectedNPC.npc_name}</h2>
          <p style={{ color: '#999', marginBottom: '10px' }}>Relationship Level: {selectedNPC.level_name}</p>
          <RelationshipMeter points={selectedNPC.points} />
          <p style={{ fontSize: '0.9em', marginTop: '15px' }}>{selectedNPC.notes}</p>
          <p style={{ fontSize: '0.8em', color: '#666', marginTop: '10px' }}>
            First Met: {new Date(selectedNPC.first_met_at).toLocaleDateString()}
          </p>
        </div>
        <button className="term-button" onClick={() => setSelectedNPC(null)}>
          BACK TO LIST
        </button>
      </div>
    );
  }

  return (
    <div className="terminal-box">
      <h1>[MENU: RELATIONS]</h1>
      <p style={{ color: '#999', marginBottom: '20px' }}>NPCs and characters you've encountered</p>
      
      {relationships.length === 0 ? (
        <p>No relationships yet. Meet NPCs on your journey!</p>
      ) : (
        relationships.map((rel) => (
          <div
            key={rel.id}
            onClick={() => setSelectedNPC(rel)}
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
              <span style={{ fontWeight: 'bold' }}>{rel.npc_name}</span>
              <span style={{ fontSize: '0.9em', color: '#999' }}>{rel.level_name}</span>
            </div>
            <div style={{ background: '#111', height: '8px', marginTop: '8px' }}>
              <div
                style={{
                  background: rel.points > 0 ? '#00ff00' : rel.points < 0 ? '#ff0000' : '#666666',
                  height: '100%',
                  width: `${Math.max(0, Math.min(100, (rel.points + 100) / 2))}%`,
                }}
              />
            </div>
          </div>
        ))
      )}

      <button className="term-button" onClick={onBack} style={{ marginTop: '20px' }}>
        BACK
      </button>
    </div>
  );
}

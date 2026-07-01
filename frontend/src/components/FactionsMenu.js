import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';

export default function FactionsMenu({ characterId, onBack }) {
  const [factions, setFactions] = useState([]);
  const [reputations, setReputations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedFaction, setSelectedFaction] = useState(null);
  const [view, setView] = useState('factions'); // 'factions' or 'reputation'

  useEffect(() => {
    loadData();
  }, [characterId]);

  const loadData = async () => {
    try {
      const [factionsRes, repRes] = await Promise.all([
        apiClient.getFactions(characterId),
        apiClient.getReputation(characterId),
      ]);

      if (factionsRes.success) setFactions(factionsRes.factions || []);
      if (repRes.success) setReputations(repRes.reputations || []);
    } catch (err) {
      console.error('Failed to load factions:', err);
    } finally {
      setLoading(false);
    }
  };

  const getReputationColor = (points) => {
    if (points <= -50) return '#ff0000';
    if (points < 0) return '#ff6600';
    if (points < 50) return '#666666';
    if (points < 100) return '#ffff00';
    return '#00ff00';
  };

  if (loading) return <div className="terminal-box">Loading factions...</div>;

  if (selectedFaction && view === 'factions') {
    const rep = reputations.find((r) => r.faction_id === selectedFaction.id);
    return (
      <div className="terminal-box">
        <h1>[FACTION: {selectedFaction.name.toUpperCase()}]</h1>
        <div style={{ border: '1px solid #333', padding: '15px', marginBottom: '20px' }}>
          <p>
            <strong>Leader:</strong> {selectedFaction.leader || 'Unknown'}
          </p>
          <p>
            <strong>Headquarters:</strong> {selectedFaction.headquarters || 'Unknown'}
          </p>
          <p>
            <strong>Alignment:</strong> {selectedFaction.alignment}
          </p>
          <p>
            <strong>Members:</strong> {selectedFaction.member_count}
          </p>
          <p>
            <strong>Description:</strong> {selectedFaction.description}
          </p>
          {rep && (
            <div style={{ marginTop: '15px', paddingTop: '15px', borderTop: '1px solid #333' }}>
              <p>
                <strong>Your Reputation:</strong>
                <span style={{ marginLeft: '10px', color: getReputationColor(rep.points) }}>
                  {rep.level_name}
                </span>
              </p>
              <div style={{ background: '#111', height: '10px', marginTop: '8px' }}>
                <div
                  style={{
                    background: getReputationColor(rep.points),
                    height: '100%',
                    width: `${Math.max(0, Math.min(100, (rep.points + 100) / 2))}%`,
                  }}
                />
              </div>
              <p style={{ fontSize: '0.8em', color: '#999', marginTop: '5px' }}>
                Points: {rep.points}
              </p>
            </div>
          )}
        </div>
        <button className="term-button" onClick={() => setSelectedFaction(null)}>
          BACK TO LIST
        </button>
      </div>
    );
  }

  if (view === 'reputation') {
    return (
      <div className="terminal-box">
        <h1>[MENU: REPUTATION]</h1>
        <p style={{ color: '#999', marginBottom: '20px' }}>Your standing with various factions</p>

        {reputations.length === 0 ? (
          <p>No faction reputation yet.</p>
        ) : (
          reputations.map((rep) => (
            <div
              key={rep.id}
              style={{
                border: '1px solid #333',
                padding: '10px',
                marginBottom: '10px',
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span style={{ fontWeight: 'bold' }}>{rep.faction_name}</span>
                <span
                  style={{
                    fontSize: '0.9em',
                    color: getReputationColor(rep.points),
                    fontWeight: 'bold',
                  }}
                >
                  {rep.level_name}
                </span>
              </div>
              <div style={{ background: '#111', height: '8px', marginTop: '8px' }}>
                <div
                  style={{
                    background: getReputationColor(rep.points),
                    height: '100%',
                    width: `${Math.max(0, Math.min(100, (rep.points + 100) / 2))}%`,
                  }}
                />
              </div>
              <p style={{ fontSize: '0.8em', color: '#999', marginTop: '5px' }}>
                {rep.points} points
              </p>
            </div>
          ))
        )}

        <button className="term-button" onClick={() => setView('factions')}>
          VIEW FACTIONS
        </button>
        <button className="term-button" onClick={onBack}>
          BACK
        </button>
      </div>
    );
  }

  return (
    <div className="terminal-box">
      <h1>[MENU: FACTIONS]</h1>
      <p style={{ color: '#999', marginBottom: '20px' }}>Organizations and groups you've discovered</p>

      {factions.length === 0 ? (
        <p>No factions discovered yet.</p>
      ) : (
        factions.map((faction) => (
          <div
            key={faction.id}
            onClick={() => setSelectedFaction(faction)}
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
              <span style={{ fontWeight: 'bold' }}>{faction.name}</span>
              <span style={{ fontSize: '0.9em', color: '#999' }}>{faction.member_count} members</span>
            </div>
            <p style={{ fontSize: '0.8em', color: '#999', margin: '5px 0 0 0' }}>
              Leader: {faction.leader || 'Unknown'} | Alignment: {faction.alignment}
            </p>
          </div>
        ))
      )}

      <button className="term-button" onClick={() => setView('reputation')} style={{ marginRight: '5px' }}>
        VIEW REPUTATION
      </button>
      <button className="term-button" onClick={onBack}>
        BACK
      </button>
    </div>
  );
}

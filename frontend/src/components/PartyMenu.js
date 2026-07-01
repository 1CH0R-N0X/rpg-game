import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';

export default function PartyMenu({ characterId, onBack, onAddNPC }) {
  const [partyMembers, setPartyMembers] = useState([]);
  const [npcs, setNpcs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showRecruitment, setShowRecruitment] = useState(false);
  const [npcForm, setNpcForm] = useState({
    npc_name: '',
    role: 'Warrior',
    hp: 15,
  });

  useEffect(() => {
    loadParty();
  }, [characterId]);

  const loadParty = async () => {
    try {
      const response = await apiClient.getParty(characterId);
      if (response.success) {
        setPartyMembers(response.party || []);
      }
    } catch (err) {
      console.error('Failed to load party:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleAddNPC = async () => {
    if (!npcForm.npc_name.trim()) return;
    
    try {
      const response = await apiClient.addNPC(characterId, {
        npc_name: npcForm.npc_name,
        role: npcForm.role,
        hp: npcForm.hp,
      });
      
      if (response.success) {
        setPartyMembers([...partyMembers, response.party_member]);
        setNpcForm({ npc_name: '', role: 'Warrior', hp: 15 });
        setShowRecruitment(false);
      }
    } catch (err) {
      console.error('Failed to add NPC:', err);
    }
  };

  if (loading) return <div className="terminal-box">Loading party...</div>;

  if (showRecruitment) {
    return (
      <div className="terminal-box">
        <h1>[RECRUITMENT]</h1>
        <div style={{ marginBottom: '20px' }}>
          <label style={{ display: 'block', marginBottom: '5px' }}>NPC NAME:</label>
          <input
            type="text"
            placeholder="Enter NPC name..."
            value={npcForm.npc_name}
            onChange={(e) => setNpcForm({ ...npcForm, npc_name: e.target.value })}
            style={{
              width: '100%',
              padding: '8px',
              marginBottom: '15px',
              background: '#111',
              border: '1px solid #333',
              color: '#d1d1d1',
              fontFamily: 'Courier New, monospace',
            }}
          />

          <label style={{ display: 'block', marginBottom: '5px' }}>ROLE:</label>
          <select
            value={npcForm.role}
            onChange={(e) => setNpcForm({ ...npcForm, role: e.target.value })}
            style={{
              width: '100%',
              padding: '8px',
              marginBottom: '15px',
              background: '#111',
              border: '1px solid #333',
              color: '#d1d1d1',
              fontFamily: 'Courier New, monospace',
            }}
          >
            <option>Warrior</option>
            <option>Mage</option>
            <option>Rogue</option>
            <option>Cleric</option>
            <option>Ranger</option>
            <option>Paladin</option>
          </select>

          <label style={{ display: 'block', marginBottom: '5px' }}>HP:</label>
          <input
            type="number"
            value={npcForm.hp}
            onChange={(e) => setNpcForm({ ...npcForm, hp: parseInt(e.target.value) })}
            style={{
              width: '100%',
              padding: '8px',
              marginBottom: '15px',
              background: '#111',
              border: '1px solid #333',
              color: '#d1d1d1',
              fontFamily: 'Courier New, monospace',
            }}
          />
        </div>

        <button className="term-button" onClick={handleAddNPC}>
          RECRUIT
        </button>
        <button className="term-button" onClick={() => setShowRecruitment(false)}>
          CANCEL
        </button>
      </div>
    );
  }

  return (
    <div className="terminal-box">
      <h1>[MENU: PARTY]</h1>
      <p style={{ color: '#999', marginBottom: '20px' }}>Your companions on this journey</p>

      {partyMembers.length === 0 ? (
        <p>No party members yet.</p>
      ) : (
        partyMembers.map((member) => (
          <div
            key={member.id}
            style={{
              border: '1px solid #333',
              padding: '10px',
              marginBottom: '10px',
            }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span style={{ fontWeight: 'bold' }}>{member.npc_name}</span>
              <span style={{ fontSize: '0.9em', color: '#999' }}>{member.role}</span>
            </div>
            <div style={{ fontSize: '0.9em', marginTop: '5px' }}>
              HP: {member.hp} / {member.max_hp}
            </div>
            <div style={{ background: '#111', height: '6px', marginTop: '5px' }}>
              <div
                style={{
                  background: '#ff3333',
                  height: '100%',
                  width: `${(member.hp / member.max_hp) * 100}%`,
                }}
              />
            </div>
          </div>
        ))
      )}

      <button
        className="term-button"
        onClick={() => setShowRecruitment(true)}
        style={{ marginTop: '20px' }}
      >
        RECRUIT NPC
      </button>
      <button className="term-button" onClick={onBack}>
        BACK
      </button>
    </div>
  );
}

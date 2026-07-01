import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';

export default function QuestMenu({ characterId, onBack, addLog }) {
  const [quests, setQuests] = useState([]);
  const [npcs, setNPCs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showNPCList, setShowNPCList] = useState(false);
  const [selectedQuest, setSelectedQuest] = useState(null);

  useEffect(() => {
    loadData();
  }, [characterId]);

  const loadData = async () => {
    try {
      const [questRes, relRes] = await Promise.all([
        apiClient.getQuests(characterId),
        apiClient.getRelationships(characterId),
      ]);

      if (questRes.success) setQuests(questRes.quests || []);
      if (relRes.success) setNPCs(relRes.relationships || []);
    } catch (err) {
      console.error('Failed to load quests:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateQuest = async (npcId) => {
    try {
      const response = await apiClient.createQuestFromNPC(characterId, npcId);
      if (response.success) {
        addLog(`New quest received: ${response.quest.title}`);
        loadData();
        setShowNPCList(false);
      }
    } catch (err) {
      addLog(`Error: ${err.message}`);
    }
  };

  const handleCompleteQuest = async (questId) => {
    try {
      const response = await apiClient.completeQuest(characterId, questId);
      if (response.success) {
        addLog(`Quest completed! +${response.data.exp_gained} EXP, +${response.data.gold_gained} Gold`);
        loadData();
        setSelectedQuest(null);
      }
    } catch (err) {
      addLog(`Error: ${err.message}`);
    }
  };

  if (loading) return <div className="terminal-box">Loading quests...</div>;

  if (showNPCList) {
    return (
      <div className="terminal-box">
        <h1>[AVAILABLE QUESTS]</h1>
        <p style={{ color: '#999', marginBottom: '20px' }}>Talk to NPCs to receive quests</p>

        {npcs.length === 0 ? (
          <p>No NPCs met yet. Explore to meet new characters!</p>
        ) : (
          npcs.map((npc) => (
            <div
              key={npc.id}
              style={{
                border: '1px solid #333',
                padding: '10px',
                marginBottom: '10px',
                cursor: 'pointer',
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span style={{ fontWeight: 'bold' }}>{npc.npc_name}</span>
                <button
                  className="term-button"
                  onClick={() => handleCreateQuest(npc.npc_id)}
                  style={{ fontSize: '0.8em', padding: '3px 10px' }}
                >
                  REQUEST QUEST
                </button>
              </div>
              <p style={{ fontSize: '0.85em', color: '#999', margin: '5px 0 0 0' }}>
                {npc.level_name} standing
              </p>
            </div>
          ))
        )}

        <button className="term-button" onClick={() => setShowNPCList(false)} style={{ marginTop: '20px' }}>
          BACK
        </button>
      </div>
    );
  }

  if (selectedQuest) {
    return (
      <div className="terminal-box">
        <h1>[QUEST: {selectedQuest.title.toUpperCase()}]</h1>
        <div style={{ border: '1px solid #333', padding: '15px', marginBottom: '20px' }}>
          <p style={{ marginBottom: '10px' }}>{selectedQuest.description}</p>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px', marginTop: '10px' }}>
            <p>
              <strong>Type:</strong> {selectedQuest.quest_type}
            </p>
            <p>
              <strong>Status:</strong> {selectedQuest.status}
            </p>
            <p>
              <strong>Reward EXP:</strong> {selectedQuest.reward_exp}
            </p>
            <p>
              <strong>Reward Gold:</strong> {selectedQuest.reward_gold}
            </p>
          </div>
        </div>

        {selectedQuest.status === 'active' && (
          <button
            className="term-button"
            onClick={() => handleCompleteQuest(selectedQuest.id)}
            style={{ marginRight: '5px' }}
          >
            COMPLETE QUEST
          </button>
        )}
        <button className="term-button" onClick={() => setSelectedQuest(null)}>
          BACK TO LIST
        </button>
      </div>
    );
  }

  const activeQuests = quests.filter((q) => q.status === 'active');
  const completedQuests = quests.filter((q) => q.status === 'completed');

  return (
    <div className="terminal-box">
      <h1>[MENU: QUESTS]</h1>
      <p style={{ color: '#999', marginBottom: '20px' }}>Your current objectives and completed tasks</p>

      <h3 style={{ color: '#ffff00', marginTop: '20px' }}>ACTIVE QUESTS ({activeQuests.length})</h3>
      {activeQuests.length === 0 ? (
        <p>No active quests. Request one from an NPC!</p>
      ) : (
        activeQuests.map((quest) => (
          <div
            key={quest.id}
            onClick={() => setSelectedQuest(quest)}
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
            <span style={{ fontWeight: 'bold' }}>{quest.title}</span>
            <p style={{ fontSize: '0.8em', color: '#999', margin: '5px 0 0 0' }}>
              {quest.reward_exp} EXP | {quest.reward_gold} Gold
            </p>
          </div>
        ))
      )}

      <h3 style={{ color: '#33ff33', marginTop: '20px' }}>COMPLETED ({completedQuests.length})</h3>
      {completedQuests.length === 0 ? (
        <p>No completed quests yet.</p>
      ) : (
        completedQuests.slice(0, 5).map((quest) => (
          <div key={quest.id} style={{ border: '1px solid #333', padding: '10px', marginBottom: '10px', opacity: 0.6 }}>
            <span style={{ fontWeight: 'bold' }}>{quest.title}</span>
            <p style={{ fontSize: '0.8em', color: '#999', margin: '5px 0 0 0' }}>Completed</p>
          </div>
        ))
      )}

      <button
        className="term-button"
        onClick={() => setShowNPCList(true)}
        style={{ marginRight: '5px', marginTop: '20px' }}
      >
        REQUEST NEW QUEST
      </button>
      <button className="term-button" onClick={onBack}>
        BACK
      </button>
    </div>
  );
}

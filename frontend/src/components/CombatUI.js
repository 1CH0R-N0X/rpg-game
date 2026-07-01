import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';

export default function CombatUI({ combatId, onBack, characterId }) {
  const [combat, setCombat] = useState(null);
  const [loading, setLoading] = useState(true);
  const [combatLog, setCombatLog] = useState([]);
  const [currentTurnIndex, setCurrentTurnIndex] = useState(0);

  useEffect(() => {
    loadCombatState();
  }, [combatId]);

  const loadCombatState = async () => {
    try {
      const response = await apiClient.getCombatState(combatId);
      if (response.success) {
        setCombat(response.combat);
        addLog('Combat started! Initiative rolled.');
      }
    } catch (err) {
      console.error('Failed to load combat:', err);
    } finally {
      setLoading(false);
    }
  };

  const addLog = (message) => {
    setCombatLog((prev) => [message, ...prev].slice(0, 15));
  };

  const handleAttack = async (targetId) => {
    try {
      const response = await apiClient.takeCombatAction(combatId, {
        action_type: 'attack',
        target_id: targetId,
        attack_bonus: 5,
      });

      if (response.success) {
        addLog(`Attack roll: ${response.action_result}`);
        loadCombatState();
      }
    } catch (err) {
      console.error('Failed to attack:', err);
    }
  };

  const handleDefend = async () => {
    try {
      const response = await apiClient.takeCombatAction(combatId, {
        action_type: 'defend',
      });

      if (response.success) {
        addLog('You take a defensive stance!');
        loadCombatState();
      }
    } catch (err) {
      console.error('Failed to defend:', err);
    }
  };

  if (loading) return <div className="terminal-box">Loading combat...</div>;
  if (!combat) return <div className="terminal-box">Combat not found</div>;

  const allies = combat.participants.filter((p) => p.is_player);
  const enemies = combat.participants.filter((p) => !p.is_player);

  return (
    <div className="terminal-box">
      <h1>[COMBAT: ROUND {combat.round}]</h1>

      {/* Enemies */}
      <div style={{ marginBottom: '20px' }}>
        <h3 style={{ color: '#ff6666' }}>ENEMIES</h3>
        {enemies.map((enemy) => (
          <div
            key={enemy.id}
            style={{
              border: '1px solid #ff3333',
              padding: '10px',
              marginBottom: '10px',
            }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span>{enemy.participant_name}</span>
              <span>
                {enemy.hp} / {enemy.max_hp} HP
              </span>
            </div>
            <div style={{ background: '#222', height: '10px', marginTop: '5px' }}>
              <div
                style={{
                  background: '#ff3333',
                  height: '100%',
                  width: `${(enemy.hp / enemy.max_hp) * 100}%`,
                }}
              />
            </div>
            <button
              className="term-button"
              onClick={() => handleAttack(enemy.id)}
              style={{ marginTop: '10px', fontSize: '0.8em' }}
            >
              ATTACK
            </button>
          </div>
        ))}
      </div>

      {/* Player */}
      <div style={{ marginBottom: '20px' }}>
        <h3 style={{ color: '#33ff33' }}>YOUR STATUS</h3>
        {allies.map((ally) => (
          <div key={ally.id} style={{ border: '1px solid #33ff33', padding: '10px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span>{ally.participant_name}</span>
              <span>
                {ally.hp} / {ally.max_hp} HP
              </span>
            </div>
            <div style={{ background: '#222', height: '10px', marginTop: '5px' }}>
              <div
                style={{
                  background: '#33ff33',
                  height: '100%',
                  width: `${(ally.hp / ally.max_hp) * 100}%`,
                }}
              />
            </div>
          </div>
        ))}
      </div>

      {/* Combat Log */}
      <div style={{ marginBottom: '20px' }}>
        <h3>COMBAT LOG</h3>
        <div
          style={{
            background: '#000',
            border: '1px solid #333',
            padding: '10px',
            height: '120px',
            overflowY: 'auto',
            fontSize: '0.85em',
          }}
        >
          {combatLog.map((log, i) => (
            <p key={i} style={{ margin: '3px 0' }}>
              &gt; {log}
            </p>
          ))}
        </div>
      </div>

      {/* Actions */}
      <div>
        <button className="term-button" onClick={handleDefend}>
          DEFEND
        </button>
        <button className="term-button" onClick={onBack}>
          FLEE
        </button>
      </div>
    </div>
  );
}

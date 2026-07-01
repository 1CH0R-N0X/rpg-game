import React, { useState } from 'react';
import { apiClient } from '../api/client';

export default function SkillCheck({ player, onBack, addLog }) {
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleSkillCheck = async (skillName, statName) => {
    setLoading(true);
    try {
      const response = await apiClient.rollSkillCheck(player.id, skillName, statName);
      if (response.success) {
        const { result: rollResult } = response;
        setResult({
          skill: skillName,
          stat: statName,
          roll: rollResult.roll,
          bonus: rollResult.stat_bonus,
          total: rollResult.total,
          success: rollResult.success,
        });
        addLog(
          `[${skillName.toUpperCase()}] Rolled: ${rollResult.roll} + ${rollResult.stat_bonus} = ${rollResult.total}`
        );
      }
    } catch (err) {
      addLog(`Error: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="terminal-box">
      <h1>[SKILL CHECK]</h1>
      {result && (
        <div style={{ border: '1px solid #33ff33', padding: '10px', marginBottom: '20px' }}>
          <h2>{result.skill}</h2>
          <p>d20 roll: {result.roll}</p>
          <p>{result.stat} modifier: +{result.bonus}</p>
          <h3>Total: {result.total}</h3>
          <p style={{ color: result.success ? '#33ff33' : '#ff3333' }}>
            {result.success ? 'SUCCESS' : 'FAILED'}
          </p>
        </div>
      )}
      <button className="term-button" onClick={onBack}>
        BACK
      </button>
    </div>
  );
}

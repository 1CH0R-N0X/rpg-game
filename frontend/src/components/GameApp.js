import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';
import CharacterCreation from './CharacterCreation';
import CharacterMenu from './CharacterMenu';
import SkillCheck from './SkillCheck';
import '../style.css';

export default function GameApp() {
  const [gameState, setGameState] = useState('CHARACTER_CREATION'); // CHARACTER_CREATION, GAME_MENU, CHARACTER_MENU, SKILL_CHECK
  const [player, setPlayer] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [log, setLog] = useState(['System Initialized...', 'Welcome to the terminal.']);

  const addLog = (entry) => {
    setLog(prev => [entry, ...prev].slice(0, 10));
  };

  const handleCreateCharacter = async (characterData) => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.createCharacter(characterData);
      if (response.success) {
        setPlayer(response.character);
        addLog(`Character created: ${response.character.name}`);
        setGameState('GAME_MENU');
      } else {
        setError(response.error || 'Failed to create character');
      }
    } catch (err) {
      setError(err.message);
      addLog(`Error: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleLoadCharacter = async (characterId) => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.getCharacter(characterId);
      if (response.success) {
        setPlayer(response.character);
        addLog(`Character loaded: ${response.character.name}`);
        setGameState('GAME_MENU');
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  if (gameState === 'CHARACTER_CREATION') {
    return (
      <CharacterCreation
        onCreateCharacter={handleCreateCharacter}
        onLoadCharacter={handleLoadCharacter}
        loading={loading}
        error={error}
      />
    );
  }

  if (!player) {
    return <div className="terminal-box">Loading...</div>;
  }

  if (gameState === 'GAME_MENU') {
    return (
      <div className="terminal-box">
        <h1>[MENU: TERMINAL]</h1>
        <div className="terminal-log" style={{ background: '#000', padding: '10px', marginBottom: '20px' }}>
          {log.map((entry, i) => (
            <p key={i}>{entry}</p>
          ))}
        </div>
        <div style={{ marginBottom: '20px' }}>
          <button
            className="term-button"
            onClick={() => setGameState('CHARACTER_MENU')}
          >
            CHARACTER
          </button>
          <button className="term-button">INVENTORY</button>
          <button className="term-button">PARTY</button>
          <button className="term-button">RELATIONS</button>
          <button className="term-button">BESTIARY</button>
          <button className="term-button">STORY</button>
        </div>
      </div>
    );
  }

  if (gameState === 'CHARACTER_MENU') {
    return (
      <CharacterMenu
        player={player}
        onBack={() => setGameState('GAME_MENU')}
        onRollSkill={(skillName, statName) => setGameState('SKILL_CHECK')}
      />
    );
  }

  if (gameState === 'SKILL_CHECK') {
    return (
      <SkillCheck
        player={player}
        onBack={() => setGameState('CHARACTER_MENU')}
        addLog={addLog}
      />
    );
  }
}

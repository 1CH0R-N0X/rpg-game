import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';
import CharacterCreation from './CharacterCreation';
import CharacterMenu from './CharacterMenu';
import PartyMenu from './PartyMenu';
import RelationsMenu from './RelationsMenu';
import BestiaryMenu from './BestiaryMenu';
import FactionsMenu from './FactionsMenu';
import CombatUI from './CombatUI';
import SkillCheck from './SkillCheck';
import ExploreMenu from './ExploreMenu';
import QuestMenu from './QuestMenu';
import '../style.css';

export default function GameApp() {
  const [gameState, setGameState] = useState('CHARACTER_CREATION');
  const [player, setPlayer] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [log, setLog] = useState(['System Initialized...', 'Welcome to the terminal.']);
  const [combatId, setCombatId] = useState(null);

  const addLog = (entry) => {
    setLog(prev => [entry, ...prev].slice(0, 15));
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
            <p key={i} style={{ fontSize: '0.9em' }}>&gt; {entry}</p>
          ))}
        </div>
        <div style={{ marginBottom: '20px' }}>
          <button className="term-button" onClick={() => setGameState('EXPLORE_MENU')}>
            EXPLORE
          </button>
          <button className="term-button" onClick={() => setGameState('CHARACTER_MENU')}>
            CHARACTER
          </button>
          <button className="term-button" onClick={() => setGameState('QUEST_MENU')}>
            QUESTS
          </button>
          <button className="term-button" onClick={() => setGameState('PARTY_MENU')}>
            PARTY
          </button>
          <button className="term-button" onClick={() => setGameState('RELATIONS_MENU')}>
            RELATIONS
          </button>
          <button className="term-button" onClick={() => setGameState('BESTIARY_MENU')}>
            BESTIARY
          </button>
          <button className="term-button" onClick={() => setGameState('FACTIONS_MENU')}>
            FACTIONS
          </button>
        </div>
      </div>
    );
  }

  if (gameState === 'EXPLORE_MENU') {
    return (
      <ExploreMenu
        characterId={player.id}
        onBack={() => setGameState('GAME_MENU')}
        addLog={addLog}
      />
    );
  }

  if (gameState === 'QUEST_MENU') {
    return (
      <QuestMenu
        characterId={player.id}
        onBack={() => setGameState('GAME_MENU')}
        addLog={addLog}
      />
    );
  }

  if (gameState === 'CHARACTER_MENU') {
    return (
      <CharacterMenu
        player={player}
        onBack={() => setGameState('GAME_MENU')}
      />
    );
  }

  if (gameState === 'PARTY_MENU') {
    return (
      <PartyMenu
        characterId={player.id}
        onBack={() => setGameState('GAME_MENU')}
      />
    );
  }

  if (gameState === 'RELATIONS_MENU') {
    return (
      <RelationsMenu
        characterId={player.id}
        onBack={() => setGameState('GAME_MENU')}
      />
    );
  }

  if (gameState === 'BESTIARY_MENU') {
    return (
      <BestiaryMenu
        characterId={player.id}
        onBack={() => setGameState('GAME_MENU')}
      />
    );
  }

  if (gameState === 'FACTIONS_MENU') {
    return (
      <FactionsMenu
        characterId={player.id}
        onBack={() => setGameState('GAME_MENU')}
      />
    );
  }

  if (gameState === 'COMBAT') {
    return (
      <CombatUI
        combatId={combatId}
        characterId={player.id}
        onBack={() => {
          setCombatId(null);
          setGameState('GAME_MENU');
        }}
      />
    );
  }

  return (
    <div className="terminal-box">
      <h1>Unknown State</h1>
      <button className="term-button" onClick={() => setGameState('GAME_MENU')}>
        Return to Menu
      </button>
    </div>
  );
}

import React, { useState } from 'react';
import { initialPlayer } from './data';
import './style.css';

export default function App() {
  const [player] = useState(initialPlayer);
  const [log, setLog] = useState(["System Initialized...", "Welcome to the terminal."]);

  // Dice Logic: d20 + Bonus
  const rollSkillCheck = (skillName, statName) => {
    const roll = Math.floor(Math.random() * 20) + 1;
    const statValue = player.stats[statName];
    const total = roll + statValue;
    
    const newEntry = `[${skillName.toUpperCase()}] Roll: ${roll} + Bonus: ${statValue} = Result: ${total}`;
    
    // Add to terminal log (keep last 5 entries)
    setLog(prev => [newEntry, ...prev].slice(0, 5));
  };

  return (
    <div className="terminal-box">
      <h1>{player.name}</h1>
      
      {/* Terminal Display */}
      <div className="terminal-log" style={{ background: '#000', padding: '10px', marginBottom: '20px' }}>
        {log.map((entry, i) => <p key={i}>{entry}</p>)}
      </div>

      <h3>SKILLS</h3>
      {Object.entries(player.skills).map(([statName, skillList]) => (
        <div key={statName}>
          <small>{statName.toUpperCase()}:</small>
          {skillList.map(skill => (
            <button 
              className="term-button" 
              key={skill} 
              onClick={() => rollSkillCheck(skill, statName)}
            >
              {skill}
            </button>
          ))}
        </div>
      ))}
    </div>
  );
}
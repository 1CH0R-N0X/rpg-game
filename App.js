import React, { useState } from 'react';
import { initialPlayer } from './data';
import './style.css';

export default function App() {
  const [player] = useState(initialPlayer);

  return (
    <div className="terminal-box">
      <h1>{player.name}</h1>
      
      {/* Stats Section */}
      <h3>STATS</h3>
      {Object.entries(player.stats).map(([stat, val]) => (
        <p key={stat}>{stat}: {val}</p>
      ))}

      {/* Skills Section */}
      <h3>SKILLS</h3>
      {Object.entries(player.skills).map(([stat, skills]) => (
        <div key={stat}>
          <small>{stat.toUpperCase()}:</small>
          {skills.map(skill => (
            <button className="term-button" key={skill} onClick={() => alert(`Rolling for ${skill}...`)}>
              {skill}
            </button>
          ))}
        </div>
      ))}
    </div>
  );
}
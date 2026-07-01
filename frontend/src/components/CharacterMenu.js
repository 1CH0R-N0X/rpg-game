import React from 'react';

export default function CharacterMenu({ player, onBack, onRollSkill }) {
  const skills = {
    Strength: ['Athletics'],
    Dexterity: ['Acrobatics', 'Sleight of Hand', 'Stealth'],
    Intellect: ['Arcana', 'History', 'Investigation', 'Nature', 'Religion'],
    Wisdom: ['Animal Handling', 'Insight', 'Medicine', 'Perception', 'Survival'],
    Charisma: ['Deception', 'Intimidation', 'Performance', 'Persuasion'],
  };

  return (
    <div className="terminal-box">
      <h1>[MENU: CHARACTER]</h1>

      <div style={{ marginBottom: '20px' }}>
        <div style={{ border: '1px solid #333', padding: '10px', marginBottom: '10px' }}>
          <h2>{player.name}</h2>
          <p>
            {player.race} · {player.class}
          </p>
        </div>

        <div style={{ border: '1px solid #333', padding: '10px', marginBottom: '10px' }}>
          <h3>LEVEL {player.level}</h3>
          <p>{player.exp} / 100 EXP</p>
          <div style={{ background: '#222', height: '10px', borderRadius: '2px' }}>
            <div
              style={{
                background: '#33ff33',
                height: '100%',
                width: `${(player.exp / 100) * 100}%`,
              }}
            />
          </div>
        </div>

        <div style={{ border: '1px solid #333', padding: '10px', marginBottom: '10px' }}>
          <h3>HP</h3>
          <p>
            {player.hp} / {player.max_hp}
          </p>
          <div style={{ background: '#222', height: '10px', borderRadius: '2px' }}>
            <div
              style={{
                background: '#ff3333',
                height: '100%',
                width: `${(player.hp / player.max_hp) * 100}%`,
              }}
            />
          </div>
        </div>

        <div style={{ border: '1px solid #333', padding: '10px', marginBottom: '10px' }}>
          <h3>STATS</h3>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px' }}>
            {Object.entries(player.stats).map(([stat, value]) => (
              <p key={stat}>
                {stat}: <strong>{value}</strong>
              </p>
            ))}
          </div>
        </div>
      </div>

      <h3>SKILLS</h3>
      {Object.entries(skills).map(([stat, skillList]) => (
        <div key={stat} style={{ marginBottom: '10px' }}>
          <p style={{ color: '#999', fontSize: '0.9em' }}>{stat.toUpperCase()}:</p>
          {skillList.map((skill) => (
            <button
              key={skill}
              className="term-button"
              onClick={() => onRollSkill(skill, stat)}
            >
              {skill}
            </button>
          ))}
        </div>
      ))}

      <button className="term-button" onClick={onBack} style={{ marginTop: '20px' }}>
        BACK
      </button>
    </div>
  );
}

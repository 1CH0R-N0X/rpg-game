import React, { useState } from 'react';

const RACES = ['Human', 'Elf', 'Dwarf', 'Halfling', 'Half-Orc'];
const CLASSES = ['Scavenger', 'Drifter', 'Enforcer'];

export default function CharacterCreation({ onCreateCharacter, onLoadCharacter, loading, error }) {
  const [step, setStep] = useState('NAME'); // NAME, RACE, CLASS, STATS, BACKSTORY, REVIEW
  const [formData, setFormData] = useState({
    name: '',
    race: 'Human',
    class: 'Scavenger',
    stats: {
      Constitution: 8,
      Wisdom: 8,
      Charisma: 8,
      Strength: 8,
      Intellect: 8,
      Dexterity: 8,
    },
    backstory: '',
    availablePoints: 15,
  });

  const handleStatChange = (stat, delta) => {
    const newStats = { ...formData.stats };
    const newVal = newStats[stat] + delta;

    if (newVal >= 1 && newVal <= 20) {
      const currentTotal = Object.values(newStats).reduce((a, b) => a + b, 0);
      const baseTotal = 48; // 6 stats * 8
      const used = currentTotal - baseTotal;
      const available = 15 - used;

      if (delta > 0 && available > 0) {
        newStats[stat] = newVal;
      } else if (delta < 0) {
        newStats[stat] = newVal;
      }
      setFormData({ ...formData, stats: newStats });
    }
  };

  const handleNameChange = (e) => {
    setFormData({ ...formData, name: e.target.value });
  };

  const handleRaceChange = (race) => {
    setFormData({ ...formData, race });
  };

  const handleClassChange = (cls) => {
    setFormData({ ...formData, class: cls });
  };

  const handleBackstoryChange = (e) => {
    setFormData({ ...formData, backstory: e.target.value });
  };

  const handleFinalize = () => {
    if (!formData.name.trim()) {
      alert('Please enter a character name');
      return;
    }

    const hp = 8 + Math.floor((formData.stats.Constitution - 10) / 2);
    onCreateCharacter({
      name: formData.name,
      race: formData.race,
      class: formData.class,
      stats: formData.stats,
      backstory: formData.backstory,
      hp: Math.max(hp, 1),
    });
  };

  if (step === 'NAME') {
    return (
      <div className="terminal-box">
        <h1>CHARACTER CREATION</h1>
        <label>NAME</label>
        <input
          type="text"
          placeholder="Enter character name..."
          value={formData.name}
          onChange={handleNameChange}
          onKeyPress={(e) => e.key === 'Enter' && setStep('RACE')}
        />
        <button className="term-button" onClick={() => setStep('RACE')}>
          CONTINUE
        </button>
      </div>
    );
  }

  if (step === 'RACE') {
    return (
      <div className="terminal-box">
        <h1>CHARACTER CREATION</h1>
        <h3>SELECT RACE</h3>
        {RACES.map((race) => (
          <button
            key={race}
            className="term-button"
            onClick={() => handleRaceChange(race)}
            style={{
              background: race === formData.race ? '#d1d1d1' : 'transparent',
              color: race === formData.race ? '#0a0a0a' : '#d1d1d1',
            }}
          >
            {race}
          </button>
        ))}
        <button
          className="term-button"
          onClick={() => setStep('CLASS')}
          style={{ marginTop: '20px' }}
        >
          CONTINUE
        </button>
      </div>
    );
  }

  if (step === 'CLASS') {
    return (
      <div className="terminal-box">
        <h1>CHARACTER CREATION</h1>
        <h3>SELECT CLASS</h3>
        {CLASSES.map((cls) => (
          <button
            key={cls}
            className="term-button"
            onClick={() => handleClassChange(cls)}
            style={{
              background: cls === formData.class ? '#d1d1d1' : 'transparent',
              color: cls === formData.class ? '#0a0a0a' : '#d1d1d1',
            }}
          >
            {cls}
          </button>
        ))}
        <button
          className="term-button"
          onClick={() => setStep('STATS')}
          style={{ marginTop: '20px' }}
        >
          CONTINUE
        </button>
      </div>
    );
  }

  if (step === 'STATS') {
    const used = Object.values(formData.stats).reduce((a, b) => a + b, 0) - 48;
    const available = 15 - used;

    return (
      <div className="terminal-box">
        <h1>CHARACTER CREATION</h1>
        <h3>STAT ALLOCATION</h3>
        <p>Available Points: {available}</p>
        {Object.entries(formData.stats).map(([stat, value]) => (
          <div key={stat}>
            <label>{stat}</label>
            <button onClick={() => handleStatChange(stat, -1)}>[-]</button>
            <span>{value}</span>
            <button onClick={() => handleStatChange(stat, 1)}>[+]</button>
          </div>
        ))}
        <button
          className="term-button"
          onClick={() => setStep('BACKSTORY')}
          style={{ marginTop: '20px' }}
        >
          CONTINUE
        </button>
      </div>
    );
  }

  if (step === 'BACKSTORY') {
    return (
      <div className="terminal-box">
        <h1>CHARACTER CREATION</h1>
        <h3>APPEARANCE & BACKSTORY</h3>
        <textarea
          placeholder="Write a brief backstory..."
          value={formData.backstory}
          onChange={handleBackstoryChange}
          rows={5}
        />
        <button
          className="term-button"
          onClick={() => setStep('REVIEW')}
          style={{ marginTop: '20px' }}
        >
          FINALIZE
        </button>
      </div>
    );
  }

  // REVIEW
  return (
    <div className="terminal-box">
      <h1>CHARACTER REVIEW</h1>
      <p>Name: {formData.name}</p>
      <p>Race: {formData.race}</p>
      <p>Class: {formData.class}</p>
      <p>HP: {8 + Math.floor((formData.stats.Constitution - 10) / 2)}</p>
      <button
        className="term-button"
        onClick={handleFinalize}
        disabled={loading}
      >
        {loading ? 'CREATING...' : 'CREATE CHARACTER'}
      </button>
      {error && <p style={{ color: 'red' }}>{error}</p>}
    </div>
  );
}

import React, { useState, useEffect } from 'react';
import { apiClient } from '../api/client';
import GameApp from './components/GameApp';
import '../style.css';

export default function App() {
  return <GameApp />;
}

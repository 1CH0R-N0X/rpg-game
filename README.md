# N.O.X — Nexus Of eXiles

Small web-based D&D-inspired RPG project. This repository contains a Ruby/Sinatra backend and a React frontend.

Getting started (local development)

Backend (Ruby)

```bash
cd backend
bundle install
ruby db/init.rb
rackup config.ru -o 0.0.0.0
```

Frontend (React)

```bash
cd frontend
npm install
npm start
```

API

- Health: `GET /api/health`
- Characters: `POST /api/characters`, `GET /api/characters`, `GET /api/characters/:id`

Roadmap / Suggestions

- Progression systems (talent trees, equipment tiers)
- More factions, branching quests, procedural side content
- Improved combat: cooldowns, AI behaviors, combat log visualization
- Narrative AI integration (optional, via OpenAI)
- Authentication and request validation
- Frontend: responsive design, accessibility, onboarding
- Tests and CI (unit/integration)

Contributing

See CONTRIBUTING.md for contribution guidelines.
# Dark RPG - D&D Text-Based Web Game

A full-stack D&D-style text-based RPG web game with terminal aesthetic, built with React (frontend) and Ruby + natural_20 (backend).

## Features

✨ **Character Creation** - Create heroes with races, classes, and stat allocation
✨ **D&D Mechanics** - Uses natural_20 gem for authentic D&D 5e-style gameplay
✨ **Skill Checks** - Roll d20 skill checks with stat bonuses
✨ **Combat System** - Turn-based combat with initiative and damage rolls
✨ **Inventory** - Manage items, weapons, and equipment
✨ **Party System** - Recruit and manage NPCs to join your party
✨ **Persistence** - Save all character data to SQLite database
✨ **Terminal UI** - Immersive dark-themed terminal-style interface

## Project Structure

```
rpg-game/
├── frontend/                  # React web app
│   ├── src/
│   │   ├── components/        # React components (GameApp, CharacterCreation, etc.)
│   │   ├── api/              # API client for backend communication
│   │   └── style.css         # Terminal styling
│   ├── package.json
│   └── public/
│
├── backend/                   # Ruby + Sinatra API
│   ├── app.rb                # Main Sinatra application
│   ├── config.ru             # Rack configuration
│   ├── Gemfile               # Ruby dependencies
│   ├── models/               # ActiveRecord models
│   ├── controllers/          # API controllers
│   ├── lib/                  # Game and combat engines
│   ├── db/
│   │   ├── schema.rb         # Database schema
│   │   ├── init.rb           # Database initialization
│   │   └── rpg_game.db       # SQLite database
│   └── README.md
│
└── README.md
```

## Setup & Installation

### Backend Setup

```bash
cd backend
bundle install
ruby db/init.rb          # Initialize SQLite database
rackup config.ru         # Start server on http://localhost:9292
```

### Frontend Setup

```bash
cd frontend
npm install
echo 'REACT_APP_API_URL=http://localhost:9292/api' > .env
npm start                # Start React dev server on http://localhost:3000
```

## How to Play

1. **Create a Character** - Choose race, class, allocate stats, write backstory
2. **Enter the Game** - View your character sheet and available actions
3. **Roll Skills** - Perform skill checks with d20 + stat modifiers
4. **Fight Enemies** - Engage in turn-based combat encounters
5. **Manage Inventory** - Collect items and equipment
6. **Recruit Party** - Add NPCs to join your adventure

## Main Menus

- **TERMINAL** - Story console and main actions
- **CHARACTER** - View stats, skills, and perform skill checks
- **INVENTORY** - Manage items and equipment
- **PARTY** - View and recruit party members
- **RELATIONS** - Track relationships and reputation
- **BESTIARY** - Catalog of encountered enemies

## API Endpoints

### Characters
- `POST /api/characters` - Create new character
- `GET /api/characters` - List all characters
- `GET /api/characters/:id` - Get character details
- `PUT /api/characters/:id` - Update character

### Skills & Combat
- `POST /api/skill-check` - Roll a skill check
- `POST /api/combat/start` - Start combat encounter
- `GET /api/combat/:id` - Get combat state
- `POST /api/combat/:id/action` - Take combat action

### Inventory & Party
- `GET /api/inventory/:character_id` - Get inventory
- `POST /api/inventory/:character_id/items` - Add item
- `GET /api/party/:character_id` - Get party members
- `POST /api/party/:character_id/add-npc` - Recruit NPC

## Technology Stack

**Frontend:**
- React 18
- Fetch API for HTTP requests
- CSS for terminal styling

**Backend:**
- Ruby 3.x
- Sinatra (web framework)
- ActiveRecord (ORM)
- SQLite3 (database)
- natural_20 gem (D&D mechanics)

## Future Enhancements

- [ ] Procedural dungeon generation
- [ ] More enemy types and boss fights
- [ ] Leveling and ability progression
- [ ] Quest system
- [ ] Spell casting and magic system
- [ ] Multiplayer support
- [ ] Save/load multiple characters
- [ ] Equipment crafting

## License

MIT

# RPG Game Backend

Ruby backend for the D&D text-based RPG game using natural_20 gem.

## Setup

```bash
# Install dependencies
bundle install

# Initialize database
ruby db/init.rb

# Run server
rackup config.ru
```

Server runs on `http://localhost:9292`

## API Endpoints

### Health
- `GET /api/health` - Check server status

### Characters
- `POST /api/characters` - Create character
- `GET /api/characters` - List all characters
- `GET /api/characters/:id` - Get character details
- `PUT /api/characters/:id` - Update character

### Skills
- `POST /api/skill-check` - Roll skill check

### Combat
- `POST /api/combat/start` - Start combat encounter
- `GET /api/combat/:combat_id` - Get combat state
- `POST /api/combat/:combat_id/action` - Take combat action

### Inventory
- `GET /api/inventory/:character_id` - Get character inventory
- `POST /api/inventory/:character_id/items` - Add item

### Party
- `GET /api/party/:character_id` - Get party members
- `POST /api/party/:character_id/add-npc` - Add NPC to party

## Architecture

- **Models**: Character, InventoryItem, PartyMember, CombatState, CombatParticipant
- **Controllers**: Handle API requests and responses
- **Game Engine**: D&D mechanics using natural_20
- **Combat Engine**: Turn-based combat with initiative
- **Database**: SQLite for persistence

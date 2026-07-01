require 'sinatra'
require 'sinatra/cors'
require 'json'
require 'sqlite3'
require 'active_record'
require 'natural_20'
require 'dotenv/load'

# Database Configuration
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './db/rpg_game.db'
)

# Enable CORS
class RPGGameAPI < Sinatra::Base
  set :allow_origin, '*'
  set :allow_methods, 'GET,HEAD,POST,PUT,DELETE,OPTIONS'
  set :allow_headers, 'Content-Type,Authorization'

  # Require all models and controllers
  Dir.glob('./lib/**/*.rb').each { |file| require file }
  Dir.glob('./models/**/*.rb').each { |file| require file }
  Dir.glob('./controllers/**/*.rb').each { |file| require file }

  # Health check
  get '/api/health' do
    content_type :json
    { status: 'ok', message: 'RPG Game API is running' }.to_json
  end

  # Character routes
  post '/api/characters' do
    CharacterController.create(request.body.read)
  end

  get '/api/characters/:id' do
    CharacterController.get(params[:id])
  end

  get '/api/characters' do
    CharacterController.list
  end

  put '/api/characters/:id' do
    CharacterController.update(params[:id], request.body.read)
  end

  # Skill check route
  post '/api/skill-check' do
    GameController.skill_check(request.body.read)
  end

  # Combat routes
  post '/api/combat/start' do
    CombatController.start(request.body.read)
  end

  post '/api/combat/:combat_id/action' do
    CombatController.take_action(params[:combat_id], request.body.read)
  end

  get '/api/combat/:combat_id' do
    CombatController.get_state(params[:combat_id])
  end

  # Inventory routes
  post '/api/inventory/:character_id/items' do
    InventoryController.add_item(params[:character_id], request.body.read)
  end

  get '/api/inventory/:character_id' do
    InventoryController.get(params[:character_id])
  end

  # Party/NPC routes
  post '/api/party/:character_id/add-npc' do
    PartyController.add_npc(params[:character_id], request.body.read)
  end

  get '/api/party/:character_id' do
    PartyController.get(params[:character_id])
  end

  # Relationships routes
  get '/api/relationships/:character_id' do
    RelationshipsController.get_all(params[:character_id])
  end

  post '/api/relationships/:character_id/:npc_id/update' do
    data = JSON.parse(request.body.read)
    RelationshipsController.update_relationship(
      params[:character_id],
      params[:npc_id],
      data['point_change'],
      data['context']
    )
  end

  # Bestiary routes
  get '/api/bestiary/:character_id' do
    BestiaryController.get_all(params[:character_id])
  end

  post '/api/bestiary/:character_id' do
    BestiaryController.add_entry(params[:character_id], request.body.read)
  end

  # Faction routes
  get '/api/factions/:character_id' do
    FactionsController.get_all(params[:character_id])
  end

  post '/api/factions/:character_id' do
    FactionsController.create(params[:character_id], request.body.read)
  end

  post '/api/factions/:faction_id/members' do
    data = JSON.parse(request.body.read)
    FactionsController.add_member(params[:faction_id], data['member_name'], data['npc_id'])
  end

  # Reputation routes
  get '/api/reputation/:character_id' do
    ReputationController.get_all(params[:character_id])
  end

  post '/api/reputation/:character_id/:faction_id' do
    data = JSON.parse(request.body.read)
    ReputationController.update(params[:character_id], params[:faction_id], data['point_change'])
  end

  # Narrative routes
  post '/api/narrative/encounter' do
    data = JSON.parse(request.body.read)
    NarrativeController.generate_encounter(data['character_id'], data['location'])
  end

  get '/api/narrative/dialogue/:character_id/:npc_id' do
    NarrativeController.generate_npc_dialogue(params[:character_id], params[:npc_id])
  end

  get '/api/narrative/story-log/:character_id' do
    NarrativeController.get_story_log(params[:character_id])
  end

  # Exploration routes
  post '/api/explore/:character_id' do
    ExplorationController.explore(params[:character_id])
  end

  get '/api/encounters/:character_id' do
    ExplorationController.get_encounters(params[:character_id])
  end

  # Quest routes
  get '/api/quests/:character_id' do
    QuestController.get_all(params[:character_id])
  end

  post '/api/quests/:character_id/:npc_id' do
    QuestController.create_from_npc(params[:character_id], params[:npc_id])
  end

  post '/api/quests/:character_id/:quest_id/complete' do
    QuestController.complete(params[:character_id], params[:quest_id])
  end
end

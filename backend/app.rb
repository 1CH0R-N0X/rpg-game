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
end

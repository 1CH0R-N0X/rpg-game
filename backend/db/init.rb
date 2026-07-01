require 'active_record'
require 'sqlite3'

# Create database directory if it doesn't exist
Dir.mkdir('db') unless Dir.exist?('db')

# Establish connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './db/rpg_game.db'
)

# Load schema
load './db/schema.rb'

puts "Database initialized successfully!"

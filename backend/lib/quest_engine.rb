class QuestEngine
  QUEST_TEMPLATES = [
    {
      title: 'Defeat the Bandits',
      description: 'Local bandits have been terrorizing travelers.',
      type: 'combat',
      reward_exp: 200,
      reward_gold: 100
    },
    {
      title: 'Retrieve the Lost Artifact',
      description: 'An ancient artifact has been stolen. Retrieve it from the dungeon.',
      type: 'retrieval',
      reward_exp: 250,
      reward_gold: 150
    },
    {
      title: 'Protect the Village',
      description: 'Strange creatures have been spotted near the village. Investigate.',
      type: 'protection',
      reward_exp: 180,
      reward_gold: 80
    },
    {
      title: 'Discover the Secret',
      description: 'Uncover the mystery hidden in the old tower.',
      type: 'exploration',
      reward_exp: 150,
      reward_gold: 60
    },
    {
      title: 'Gather Resources',
      description: 'Collect rare herbs from the forest.',
      type: 'gathering',
      reward_exp: 100,
      reward_gold: 50
    },
  ].freeze

  def self.generate_quest_for_npc(character_id, npc_id)
    npc = NPC.find(npc_id)
    quest_template = QUEST_TEMPLATES.sample

    quest = Quest.create!(
      character_id: character_id,
      npc_id: npc_id,
      title: "#{quest_template[:title]} (#{npc.name}\'s Request)",
      description: quest_template[:description],
      quest_type: quest_template[:type],
      status: 'active',
      reward_exp: quest_template[:reward_exp],
      reward_gold: quest_template[:reward_gold]
    )

    StoryEvent.create!(
      character_id: character_id,
      event_type: 'quest',
      description: "#{npc.name} has given you a quest: #{quest.title}",
      npc_involved: npc.name
    )

    quest
  end

  def self.complete_quest(character_id, quest_id)
    character = Character.find(character_id)
    quest = Quest.find(quest_id)

    unless quest.status == 'active'
      return { success: false, error: 'Quest is not active' }
    end

    # Grant rewards
    character.update(
      exp: character.exp + quest.reward_exp,
      coins: character.coins + quest.reward_gold
    )

    # Update quest
    quest.update(
      status: 'completed',
      completed_at: Time.now
    )

    # Increase relationship with quest giver
    if quest.npc_id
      relationship = Relationship.find_by(character_id: character_id, npc_id: quest.npc_id)
      if relationship
        relationship.update(points: relationship.points + 10, last_interaction: Time.now)
      end
    end

    StoryEvent.create!(
      character_id: character_id,
      event_type: 'quest',
      description: "You completed: #{quest.title} - Earned #{quest.reward_exp} exp and #{quest.reward_gold} gold!",
      npc_involved: quest.npc&.name
    )

    {
      success: true,
      exp_gained: quest.reward_exp,
      gold_gained: quest.reward_gold
    }
  end
end

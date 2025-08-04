-- Enhanced Twin Academy Worlds Database Schema
-- Supports Three-Tier Character System and Card Battle Game

-- Add columns to existing characters table for base character properties
ALTER TABLE characters ADD COLUMN IF NOT EXISTS character_archetype VARCHAR(100); -- 'protagonist', 'rival', 'mentor', etc.
ALTER TABLE characters ADD COLUMN IF NOT EXISTS power_level INTEGER CHECK (power_level BETWEEN 1 AND 100);
ALTER TABLE characters ADD COLUMN IF NOT EXISTS canonical_stats JSONB; -- Store original performance data

-- Character Variants Table (Canon, Twin, Crossover forms)
CREATE TABLE character_variants (
    id SERIAL PRIMARY KEY,
    base_character_id INTEGER REFERENCES characters(id),
    variant_type VARCHAR(20) NOT NULL CHECK (variant_type IN ('canon', 'twin', 'crossover')),
    variant_name VARCHAR(200) NOT NULL,
    
    -- Dimensional Properties
    source_dimension_id INTEGER REFERENCES dimensions(id),
    adapted_dimension_id INTEGER REFERENCES dimensions(id), -- For twins
    fusion_partner_id INTEGER REFERENCES character_variants(id), -- For crossovers
    
    -- Card Game Stats (1-100 scale)
    power_stat INTEGER CHECK (power_stat BETWEEN 1 AND 100),
    speed_stat INTEGER CHECK (speed_stat BETWEEN 1 AND 100),
    precision_stat INTEGER CHECK (precision_stat BETWEEN 1 AND 100),
    harmony_stat INTEGER CHECK (harmony_stat BETWEEN 1 AND 100),
    focus_stat INTEGER CHECK (focus_stat BETWEEN 1 AND 100),
    fusion_stat INTEGER CHECK (fusion_stat BETWEEN 0 AND 100), -- Only for crossovers
    
    -- Card Properties
    card_rarity VARCHAR(20) CHECK (card_rarity IN ('common', 'uncommon', 'rare', 'epic', 'legendary', 'mythic')),
    card_cost INTEGER CHECK (card_cost BETWEEN 1 AND 10),
    collection_number VARCHAR(20), -- Card set numbering
    
    -- Content
    adapted_backstory TEXT,
    fusion_narrative TEXT,
    personality_adaptations TEXT[],
    dimensional_adaptation_notes TEXT,
    
    -- Media
    character_image_url TEXT,
    card_artwork_url TEXT,
    character_model_3d_url TEXT,
    
    -- Generation Metadata
    is_ai_generated BOOLEAN DEFAULT FALSE,
    generation_prompt TEXT,
    source_references TEXT[],
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Techniques/Abilities with Variants
CREATE TABLE techniques (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    japanese_name VARCHAR(200),
    base_character_id INTEGER REFERENCES characters(id),
    
    -- Technique Properties
    technique_category VARCHAR(50), -- 'special_move', 'gift', 'basic_skill'
    dimension_origin_id INTEGER REFERENCES dimensions(id),
    
    -- Canonical Information
    first_appearance_chapter INTEGER,
    first_appearance_volume INTEGER,
    canonical_description TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Technique Variants (adapted for different character variants)
CREATE TABLE technique_variants (
    id SERIAL PRIMARY KEY,
    base_technique_id INTEGER REFERENCES techniques(id),
    character_variant_id INTEGER REFERENCES character_variants(id),
    
    variant_name VARCHAR(200) NOT NULL,
    adapted_description TEXT,
    
    -- Technique Properties
    technique_type VARCHAR(50) CHECK (technique_type IN ('primary', 'secondary', 'ultimate', 'fusion', 'combo')),
    dimension_physics VARCHAR(50) CHECK (dimension_physics IN ('harmony', 'focus', 'hybrid')),
    
    -- Game Mechanics
    energy_cost INTEGER CHECK (energy_cost BETWEEN 1 AND 10),
    cooldown_turns INTEGER DEFAULT 0,
    accuracy_modifier INTEGER DEFAULT 0,
    
    -- Effects
    base_damage INTEGER,
    special_effects JSONB, -- JSON array of effect objects
    target_type VARCHAR(50), -- 'single', 'multiple', 'self', 'all'
    range_type VARCHAR(50), -- 'close', 'medium', 'long', 'area'
    
    -- Combination Requirements
    prerequisite_techniques INTEGER[], -- Array of technique IDs
    fusion_compatibility INTEGER[], -- Compatible technique IDs for combos
    dimensional_bonuses JSONB, -- Bonuses when used in specific dimensions
    
    -- Visual/Audio
    visual_effects_description TEXT,
    sound_effects_description TEXT,
    animation_reference_url TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Card Sets and Collections
CREATE TABLE card_sets (
    id SERIAL PRIMARY KEY,
    set_name VARCHAR(200) NOT NULL,
    set_code VARCHAR(10) NOT NULL UNIQUE,
    release_date DATE,
    description TEXT,
    
    -- Set Properties
    set_type VARCHAR(50), -- 'base', 'expansion', 'special', 'promotional'
    dimension_focus INTEGER REFERENCES dimensions(id), -- Primary dimension theme
    total_cards INTEGER,
    
    -- Rarity Distribution
    common_count INTEGER DEFAULT 0,
    uncommon_count INTEGER DEFAULT 0,
    rare_count INTEGER DEFAULT 0,
    epic_count INTEGER DEFAULT 0,
    legendary_count INTEGER DEFAULT 0,
    mythic_count INTEGER DEFAULT 0,
    
    artwork_style VARCHAR(100),
    artist_credits TEXT[],
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Individual Cards
CREATE TABLE cards (
    id SERIAL PRIMARY KEY,
    card_set_id INTEGER REFERENCES card_sets(id),
    character_variant_id INTEGER REFERENCES character_variants(id), -- NULL for non-character cards
    
    card_name VARCHAR(200) NOT NULL,
    card_number VARCHAR(20), -- Position in set (e.g., "001/150")
    card_type VARCHAR(50) CHECK (card_type IN ('character', 'technique', 'academy', 'dimensional', 'fusion')),
    
    -- Card Properties
    rarity VARCHAR(20) CHECK (rarity IN ('common', 'uncommon', 'rare', 'epic', 'legendary', 'mythic')),
    cost INTEGER CHECK (cost BETWEEN 0 AND 15),
    
    -- Card Effects (stored as structured JSON)
    card_effects JSONB,
    flavor_text TEXT,
    
    -- Artwork
    card_image_url TEXT,
    foil_variant_url TEXT,
    alternate_art_urls TEXT[],
    
    -- Game Balance
    ban_status VARCHAR(20) DEFAULT 'legal', -- 'legal', 'restricted', 'banned'
    balance_notes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Academy/Environment Cards
CREATE TABLE academy_cards (
    id SERIAL PRIMARY KEY,
    card_id INTEGER REFERENCES cards(id),
    academy_id INTEGER REFERENCES academies(id),
    
    -- Environment Effects
    dimensional_bonus JSONB, -- Bonuses for characters from specific dimensions
    ability_modifications JSONB, -- How abilities are modified in this environment
    special_rules TEXT[],
    
    -- Visual
    environment_description TEXT,
    background_music_reference VARCHAR(200),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Battle Game System
CREATE TABLE game_matches (
    id SERIAL PRIMARY KEY,
    match_type VARCHAR(50), -- 'practice', 'ranked', 'tournament', 'story'
    
    -- Players
    player1_id UUID, -- Supabase auth user
    player2_id UUID, -- NULL for AI matches
    
    -- Match State
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'active', 'completed', 'abandoned'
    winner_id UUID,
    turn_count INTEGER DEFAULT 0,
    current_turn_player UUID,
    
    -- Game State (stored as JSON for flexibility)
    game_state JSONB,
    match_log JSONB, -- Array of turn actions
    
    -- Metadata
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    duration_seconds INTEGER,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Player Decks
CREATE TABLE player_decks (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL, -- Supabase auth user
    deck_name VARCHAR(200) NOT NULL,
    
    -- Deck Properties
    is_active BOOLEAN DEFAULT FALSE,
    dimension_theme INTEGER REFERENCES dimensions(id),
    deck_type VARCHAR(50), -- 'canon', 'twin', 'crossover', 'mixed'
    
    -- Deck Contents (array of card IDs with quantities)
    deck_contents JSONB, -- {"card_id": quantity} format
    total_cards INTEGER,
    
    -- Deck Stats (calculated)
    average_cost DECIMAL(3,2),
    character_count INTEGER,
    technique_count INTEGER,
    academy_count INTEGER,
    
    -- Metadata
    win_count INTEGER DEFAULT 0,
    loss_count INTEGER DEFAULT 0,
    last_used TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Player Collection (cards owned)
CREATE TABLE player_collections (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    card_id INTEGER REFERENCES cards(id),
    quantity INTEGER DEFAULT 1,
    
    -- Collection Properties
    is_foil BOOLEAN DEFAULT FALSE,
    alternate_art BOOLEAN DEFAULT FALSE,
    acquisition_method VARCHAR(50), -- 'pack', 'trade', 'craft', 'reward'
    acquisition_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Card Condition (for trading)
    condition VARCHAR(20) DEFAULT 'mint', -- 'mint', 'near_mint', 'played', 'damaged'
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Story Campaigns
CREATE TABLE story_campaigns (
    id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(200) NOT NULL,
    dimension_id INTEGER REFERENCES dimensions(id),
    
    -- Campaign Properties
    difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 10),
    required_player_level INTEGER DEFAULT 1,
    recommended_deck_type VARCHAR(50),
    
    -- Story Content
    campaign_description TEXT,
    story_summary TEXT,
    canonical_basis TEXT, -- Which manga chapters/arcs this is based on
    
    -- Rewards
    completion_rewards JSONB, -- Cards, experience, etc.
    first_time_bonus JSONB,
    
    -- Media
    campaign_artwork_url TEXT,
    background_music_url TEXT,
    
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Story Campaign Battles
CREATE TABLE campaign_battles (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES story_campaigns(id),
    battle_order INTEGER,
    
    battle_name VARCHAR(200) NOT NULL,
    opponent_type VARCHAR(50), -- 'ai', 'boss', 'rival'
    
    -- AI Opponent Configuration
    ai_deck_configuration JSONB,
    ai_difficulty INTEGER CHECK (ai_difficulty BETWEEN 1 AND 10),
    ai_personality VARCHAR(100), -- 'aggressive', 'defensive', 'balanced', 'unpredictable'
    
    -- Battle Conditions
    special_rules JSONB, -- Custom rules for this battle
    victory_conditions JSONB, -- Custom win conditions
    dimensional_effects JSONB, -- Environmental modifiers
    
    -- Story Content
    pre_battle_dialogue TEXT,
    post_victory_dialogue TEXT,
    post_defeat_dialogue TEXT,
    
    -- Rewards
    victory_rewards JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Image Generation Tracking
CREATE TABLE generated_images (
    id SERIAL PRIMARY KEY,
    entity_type VARCHAR(50), -- 'character_variant', 'card', 'academy', etc.
    entity_id INTEGER,
    
    -- Generation Details
    image_type VARCHAR(50), -- 'character_portrait', 'card_art', 'full_body', 'action_scene'
    generation_prompt TEXT NOT NULL,
    style_preferences JSONB,
    
    -- Results
    image_url TEXT,
    thumbnail_url TEXT,
    generation_metadata JSONB, -- Model used, settings, etc.
    
    -- Quality Control
    quality_score INTEGER CHECK (quality_score BETWEEN 1 AND 10),
    human_approved BOOLEAN DEFAULT FALSE,
    approval_notes TEXT,
    
    -- Generation Tracking
    generation_cost DECIMAL(10,4), -- Cost in credits/tokens
    generation_time_seconds INTEGER,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Content Source Tracking (for canonical information)
CREATE TABLE content_sources (
    id SERIAL PRIMARY KEY,
    source_type VARCHAR(50), -- 'manga_chapter', 'anime_episode', 'game', 'official_guide'
    source_title VARCHAR(200),
    
    -- Source Details
    series_id INTEGER REFERENCES manga_series(id),
    chapter_number INTEGER,
    volume_number INTEGER,
    page_numbers INTEGER[],
    
    -- URLs and References
    source_url TEXT,
    archive_url TEXT,
    image_references TEXT[],
    
    -- Content Extracted
    character_appearances INTEGER[], -- character IDs
    techniques_shown INTEGER[], -- technique IDs
    story_elements TEXT[],
    
    -- Verification
    verified_by UUID, -- User who verified this source
    verification_date TIMESTAMP,
    confidence_score INTEGER CHECK (confidence_score BETWEEN 1 AND 10),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes for performance
CREATE INDEX idx_character_variants_base ON character_variants(base_character_id);
CREATE INDEX idx_character_variants_type ON character_variants(variant_type);
CREATE INDEX idx_character_variants_dimension ON character_variants(source_dimension_id, adapted_dimension_id);
CREATE INDEX idx_technique_variants_character ON technique_variants(character_variant_id);
CREATE INDEX idx_technique_variants_base ON technique_variants(base_technique_id);
CREATE INDEX idx_cards_set ON cards(card_set_id);
CREATE INDEX idx_cards_character ON cards(character_variant_id);
CREATE INDEX idx_player_collections_user ON player_collections(user_id);
CREATE INDEX idx_player_decks_user ON player_decks(user_id);
CREATE INDEX idx_game_matches_players ON game_matches(player1_id, player2_id);
CREATE INDEX idx_generated_images_entity ON generated_images(entity_type, entity_id);

-- Enable Row Level Security for user-specific tables
ALTER TABLE player_decks ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_matches ENABLE ROW LEVEL SECURITY;

-- Insert base card set
INSERT INTO card_sets (set_name, set_code, set_type, description, total_cards) VALUES 
('Twin Academy Worlds: Foundation', 'TAW001', 'base', 'The foundation set featuring Canon characters from both dimensions', 200),
('Dimensional Echoes: Twin Forms', 'TAW002', 'expansion', 'Twin character variants adapted to alternate dimensions', 150),
('Nexus Fusion: Crossover Champions', 'TAW003', 'special', 'Legendary crossover characters from Nexus Academy', 100);

-- Insert sample story campaigns
INSERT INTO story_campaigns (campaign_name, dimension_id, difficulty_level, campaign_description, canonical_basis) VALUES 
('Nankatsu Elementary Chronicles', 1, 3, 'Follow Tsubasa''s early adventures at Nankatsu Elementary', 'Captain Tsubasa Chapters 1-50'),
('Camelot Academy Trials', 2, 4, 'Experience Gawain''s journey at the prestigious Camelot Academy', 'Rising Impact Volumes 1-5'),
('The First Nexus Exchange', 3, 8, 'Epic crossover campaign where both worlds first collide', 'Original Fusion Storyline');
# Twin Academy Worlds

## Project Overview

Twin Academy Worlds is a comprehensive manga directory and integrated card battle game featuring Captain Subasa and Rising Impact in a connected multiverse. The project combines authentic manga content with innovative dimensional fusion concepts and strategic gameplay.

## Universe Concept

The Twin Academy Worlds multiverse contains three interconnected dimensions:

- **Nankatsu Dimension**: Soccer realm where team harmony amplifies individual abilities
- **Camelot Dimension**: Golf realm where individual mastery unlocks supernatural precision  
- **Nexus Academy Dimension**: Interdimensional bridge enabling cross-training and fusion

## Three-Tier Character System

### Canon Characters (Tier 1)
- Original characters from Captain Subasa and Rising Impact manga
- Authentic abilities, stats, and backstories from source material
- Foundation for all dimensional adaptations

### Twin Characters (Tier 2)
- Dimensional adaptations maintaining character essence
- Canon characters adapted to alternate dimensional physics
- New backstories fitting alternate dimensional cultures

### Crossover Characters (Tier 3)
- Legendary fusion characters from Nexus Academy
- Hybrid abilities combining both dimensional physics
- Unique fusion techniques transcending single-dimensional limits

## Project Components

### 🗄️ Database Architecture
- PostgreSQL database with Supabase compatibility
- Comprehensive character, technique, and card game systems
- User progress tracking and community features

### 🤖 AI Agent Team (19 Specialized Agents)
- Content research and archival agents
- Character adaptation and fusion designers
- Image generation and quality control
- Game balance and web development

### 🎮 Card Battle Game
- Strategic card game with dimensional physics mechanics
- Story campaigns following canonical storylines
- Tournament system with competitive play
- Collection and deck building features

### 🌐 Web Platform
- Responsive manga directory with advanced search
- Integrated card battle game interface
- Community features and social systems
- Mobile-optimized progressive web app

## Development Standards

### Character Development Requirements
- **Canon Accuracy**: All source material must be verified against official manga
- **Completeness**: Character profiles require minimum 15 data fields
- **Quality Control**: Multi-stage validation with community review
- **Consistency**: Standardized formatting and citation requirements

### Content Quality Standards
- **Source Citations**: All information linked to specific chapters/volumes
- **Translation Verification**: Japanese terms verified with native sources
- **Community Review**: Expert validation for controversial elements
- **Update Protocols**: Version control for all content modifications

## Technology Stack

- **Database**: PostgreSQL with Prisma ORM
- **Backend**: Node.js/Express with TypeScript
- **Frontend**: Next.js 14+ with React and Tailwind CSS
- **Real-time**: Socket.io for multiplayer features
- **Authentication**: Supabase Auth with social login
- **Deployment**: Vercel with global CDN
- **Image Generation**: AI-powered character artwork creation

## Project Structure

```
twin-academy-worlds/
├── agents/                 # AI agent configurations
├── database/              # Database schema and migrations
├── docs/                  # Project documentation
├── src/                   # Source code
│   ├── components/        # React components
│   ├── pages/            # Next.js pages
│   ├── api/              # API endpoints
│   └── lib/              # Utilities and configurations
├── content/              # Character data and content
├── templates/            # Character development templates
└── scripts/              # Development and deployment scripts
```

## Getting Started

### Prerequisites
- Node.js 18+
- PostgreSQL 15+
- Git and GitHub CLI

### Installation
```bash
git clone https://github.com/TamerineSky/twin-academy-worlds.git
cd twin-academy-worlds
npm install
```

### Database Setup
```bash
# Create local database
createdb twin_academy_worlds

# Run migrations
npm run db:migrate

# Seed with initial data
npm run db:seed
```

### Development
```bash
# Start development server
npm run dev

# Run agent team
npm run agents:start

# Generate character content
npm run content:generate
```

## Contributing

### Character Development Workflow
1. **Research Phase**: Use canon-content-archivist agent to gather source material
2. **Validation Phase**: Verify accuracy with sports-stats-validator agent
3. **Adaptation Phase**: Generate Twin variants with twin-character-generator
4. **Fusion Phase**: Create Crossover characters with crossover-fusion-designer
5. **Visualization Phase**: Generate artwork with character-image-generator
6. **Integration Phase**: Import to database and test with website systems

### Issue Management
- Character development tracked through standardized GitHub issues
- Quality gates enforce minimum requirements before completion
- Agent team coordination through automated workflows
- Community review process for content validation

## Roadmap

### Phase 1: Foundation (Current)
- [ ] Core database schema implementation
- [ ] Agent team deployment and testing
- [ ] Character development standards establishment
- [ ] Initial Canon character research and validation

### Phase 2: Content Population
- [ ] Complete Captain Subasa character catalog
- [ ] Complete Rising Impact character catalog
- [ ] Twin character generation for all main characters
- [ ] Initial Crossover fusion character creation

### Phase 3: Game Development
- [ ] Card game mechanics implementation
- [ ] Web interface development
- [ ] Story campaign creation
- [ ] Tournament system development

### Phase 4: Community Features
- [ ] User authentication and profiles
- [ ] Social features and community tools
- [ ] Content contribution systems
- [ ] Mobile app development

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Yoichi Takahashi for creating Captain Subasa
- Nakaba Suzuki for creating Rising Impact
- The manga communities for preserving and sharing knowledge
- All contributors to this ambitious fusion project

---

**🎌 Twin Academy Worlds - Where Dimensions Collide and Legends Are Born**
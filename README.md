# Blockchain-Based Sports Fantasy League Management

A comprehensive smart contract system built on the Stacks blockchain using Clarity for managing fantasy sports leagues with operator verification, player statistics, scoring calculations, prize distribution, and fair play monitoring.

## 🏆 Features

### Core Functionality
- **League Operator Verification**: Validates and manages fantasy sports operators
- **Player Statistics Management**: Tracks player performance and statistics
- **Scoring Engine**: Calculates fantasy league scores based on real player performance
- **Prize Distribution**: Manages contest entry fees and prize pool distribution
- **Fair Play Monitoring**: Detects suspicious activity and prevents collusion

### Smart Contracts

#### 1. League Operator Contract (`league-operator.clar`)
- Verify and manage fantasy sports operators
- Track operator licenses and verification status
- Revoke operator permissions when necessary

#### 2. Player Statistics Contract (`player-stats.clar`)
- Add and manage player profiles
- Record game performance data
- Calculate player averages and statistics
- Track season-long performance metrics

#### 3. Scoring Engine Contract (`scoring-engine.clar`)
- Create and manage fantasy lineups
- Calculate fantasy scores using configurable multipliers
- Track weekly performance and rankings
- Support live score calculations

#### 4. Prize Distribution Contract (`prize-distribution.clar`)
- Create contests with entry fees
- Manage prize pools and participant entries
- Distribute prizes to winners automatically
- Handle platform fees and revenue sharing

#### 5. Fair Play Monitor Contract (`fair-play-monitor.clar`)
- Track user activity patterns
- Detect suspicious behavior automatically
- Handle user reports and investigations
- Suspend and reinstate users as needed

## 🚀 Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd fantasy-league-blockchain
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks testnet:

\`\`\`bash
# Deploy league operator contract
clarinet deploy --testnet contracts/league-operator.clar

# Deploy player stats contract
clarinet deploy --testnet contracts/player-stats.clar

# Deploy scoring engine contract
clarinet deploy --testnet contracts/scoring-engine.clar

# Deploy prize distribution contract
clarinet deploy --testnet contracts/prize-distribution.clar

# Deploy fair play monitor contract
clarinet deploy --testnet contracts/fair-play-monitor.clar
\`\`\`

## 📊 Usage Examples

### Creating a Fantasy League

1. **Verify Operator**:
   \`\`\`clarity
   (contract-call? .league-operator verify-operator 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM "Fantasy Sports Inc" "FSI-2024-001")
   \`\`\`

2. **Add Players**:
   \`\`\`clarity
   (contract-call? .player-stats add-player "LeBron James" "SF" "Lakers")
   \`\`\`

3. **Create Contest**:
   \`\`\`clarity
   (contract-call? .prize-distribution create-contest u1000000 u12500)
   \`\`\`

4. **Create Lineup**:
   \`\`\`clarity
   (contract-call? .scoring-engine create-lineup (list u1 u2 u3 u4 u5) u1)
   \`\`\`

### Scoring System

The scoring engine uses the following multipliers:
- **Points**: 1x multiplier
- **Assists**: 2x multiplier
- **Rebounds**: 1x multiplier

Fantasy Score = (Points × 1) + (Assists × 2) + (Rebounds × 1)

### Prize Distribution

Prize pools are distributed as follows:
- **1st Place**: 60% of prize pool
- **2nd Place**: 25% of prize pool
- **3rd Place**: 15% of prize pool
- **Platform Fee**: 5% of total entry fees

## 🔒 Security Features

### Fair Play Monitoring
- **Activity Tracking**: Monitors user lineup creation and contest participation
- **Suspicious Behavior Detection**: Automatically flags unusual patterns
- **Collusion Prevention**: Detects coordinated activities between users
- **User Reporting**: Community-driven reporting system

### Access Control
- **Operator Verification**: Only verified operators can manage leagues
- **Owner Permissions**: Contract owners have administrative privileges
- **User Suspension**: Ability to suspend users for violations

## 🧪 Testing

The project includes comprehensive tests for all contracts:

\`\`\`bash
# Run all tests
npm test

# Run specific contract tests
npm test -- league-operator.test.js
npm test -- player-stats.test.js
npm test -- scoring-engine.test.js
npm test -- prize-distribution.test.js
npm test -- fair-play-monitor.test.js
\`\`\`

## 📈 Monitoring and Analytics

### Key Metrics Tracked
- Player performance statistics
- User activity patterns
- Contest participation rates
- Prize distribution history
- Fair play violations

### Reporting Features
- Real-time scoring updates
- Weekly performance summaries
- Suspicious activity alerts
- Revenue and fee tracking

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## 🔮 Future Enhancements

- Multi-sport support (NFL, MLB, NHL)
- Advanced analytics and insights
- Mobile app integration
- Social features and leagues
- NFT integration for player cards
- Decentralized governance features
  \`\`\`


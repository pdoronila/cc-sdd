# Spec-Driven Development for Claude Code

A comprehensive implementation of spec-driven development workflows using Claude Code's extensibility features.

## Overview

This project demonstrates how to implement spec-driven development using Claude Code's custom slash commands and hooks. Spec-driven development prioritizes creating detailed specifications before writing code, ensuring better planning, alignment, and maintainability.

## Features

### 🔧 Custom Slash Commands

- **`/spec-init`** - Initialize new project with comprehensive specification templates
- **`/spec-validate`** - Validate specification completeness and consistency
- **`/spec-update`** - Update specifications based on current codebase implementation  
- **`/spec-tasks`** - Generate implementation tasks from specifications
- **`/spec-review`** - Review alignment between specifications and code

### 📋 Specification Templates

#### `specs/requirements.md`
- User stories in EARS format (WHEN/THE SYSTEM SHALL/WHERE)
- Functional and non-functional requirements
- Success criteria and constraints
- Risk assessment and mitigation

#### `specs/design.md`
- System architecture and technology stack
- Component design and data models
- API design and database schema
- Security, performance, and deployment considerations

#### `specs/tasks.md`
- Implementation task breakdown with effort estimates
- Sprint planning and progress tracking
- Quality gates and definition of done
- Cross-cutting concerns (documentation, security, performance)

#### `specs/api-spec.md`
- Comprehensive API documentation
- Authentication and error handling
- Rate limiting and webhook specifications
- SDK examples and testing information

### 🔄 Automation & Hooks

#### Pre-commit Validation
- Validates specification structure and completeness
- Checks for EARS format user stories
- Ensures cross-document consistency
- Prevents commits with specification errors

#### Post-edit Synchronization
- Automatically detects code changes
- Updates specification timestamps
- Suggests when manual spec updates are needed
- Logs synchronization activities

### 🌐 MCP Server Integration

Advanced spec synchronization capabilities:
- **Drift Detection** - Identify when specs and code diverge
- **Consistency Validation** - Check alignment across documents
- **Automatic Sync** - Update specs based on code changes
- **Traceability Matrix** - Track requirements through implementation
- **Coverage Analysis** - Measure specification completeness

## Getting Started

### 1. Initialize Spec-Driven Project

```bash
# In your project directory
claude /spec-init
```

This will:
- Ask discovery questions about your project
- Generate comprehensive specification templates
- Set up the complete project structure

### 2. Configure Claude Code

The project includes `.claude/settings.local.json` with:
- Custom slash command permissions
- Pre-commit and post-edit hooks
- MCP server configuration for advanced features
- Spec-driven development system prompts

### 3. Use the Workflow

#### Planning Phase
1. Run `/spec-init` to create initial specifications
2. Use `/spec-validate` to ensure completeness
3. Run `/spec-tasks` to generate implementation plan

#### Development Phase
1. Implement features according to specifications
2. Use `/spec-update` to sync specs with code changes
3. Run `/spec-review` to check alignment

#### Quality Assurance
1. Pre-commit hooks validate specifications
2. Post-edit hooks track synchronization
3. Regular `/spec-validate` ensures consistency

## Project Structure

```
project/
├── specs/                          # Specification documents
│   ├── requirements.md             # User stories and requirements
│   ├── design.md                   # Technical architecture
│   ├── tasks.md                    # Implementation planning
│   └── api-spec.md                 # API documentation
├── .claude/                        # Claude Code configuration
│   ├── commands/                   # Custom slash commands
│   │   ├── spec-init.md            # Project initialization
│   │   ├── spec-validate.md        # Specification validation
│   │   ├── spec-update.md          # Spec-code synchronization
│   │   ├── spec-tasks.md           # Task generation
│   │   └── spec-review.md          # Alignment review
│   ├── hooks/                      # Automation scripts
│   │   ├── validate-specs.sh       # Pre-commit validation
│   │   └── sync-specs.sh           # Post-edit sync
│   ├── mcp-servers/                # MCP integration
│   │   └── spec-sync-server.js     # Advanced sync features
│   └── settings.local.json         # Claude Code configuration
└── [your implementation files]
```

## Workflow Examples

### Starting a New Feature

```bash
# 1. Plan the feature
claude /spec-init
# Answer questions about the feature requirements

# 2. Validate the specifications
claude /spec-validate
# Review any warnings or issues

# 3. Generate implementation tasks
claude /spec-tasks
# Get detailed task breakdown

# 4. Start development with clear guidance
```

### Maintaining Alignment

```bash
# After making code changes
claude /spec-update
# Synchronize specs with implementation

# Regular alignment checks
claude /spec-review
# Identify any drift between specs and code

# Validate overall consistency
claude /spec-validate
# Ensure all specifications remain coherent
```

## Advanced Features

### MCP Server Tools

The included MCP server provides additional capabilities:

- `detect_spec_drift` - Analyze divergence between specs and code
- `validate_spec_consistency` - Check cross-document alignment
- `sync_specs_with_code` - Automated specification updates
- `generate_traceability_matrix` - Requirements traceability
- `check_spec_coverage` - Measure implementation coverage

### Hook Integration

Hooks automatically:
- Validate specifications before commits
- Track synchronization when files change
- Log activities for audit trails
- Suggest when manual updates are needed

### Customization

The system is highly configurable:
- Modify templates in `specs/` for your domain
- Customize commands in `.claude/commands/`
- Adjust hooks in `.claude/hooks/`
- Configure MCP server for specific needs

## Benefits

### For Development Teams
- **Clear Requirements** - EARS format ensures testable specifications
- **Reduced Miscommunication** - Comprehensive documentation prevents misunderstandings
- **Better Planning** - Detailed task breakdown improves estimation
- **Quality Gates** - Validation ensures specifications remain current

### For Project Management
- **Traceability** - Track requirements through implementation
- **Progress Visibility** - Clear task status and completion metrics
- **Risk Management** - Early identification of scope and technical issues
- **Compliance** - Maintain audit trails of requirements and changes

### For Maintenance
- **Living Documentation** - Specifications stay synchronized with code
- **Onboarding** - New team members understand system design
- **Technical Debt** - Identify areas where implementation diverges from design
- **Change Impact** - Understand effects of modifications

## Best Practices

### Specification Writing
- Use EARS format for user stories (WHEN/SHALL/WHERE)
- Include specific, testable acceptance criteria
- Document assumptions and constraints clearly
- Regular validation and updates

### Development Process
- Start with specifications before coding
- Use `/spec-update` after significant changes
- Regular `/spec-review` to catch drift early
- Commit hooks ensure specification quality

### Team Collaboration
- Collaborative specification review sessions
- Regular alignment checks in standups
- Use traceability matrix for coverage analysis
- Document decisions and rationale

## Contributing

This is a reference implementation that can be adapted for your specific needs:

1. Fork the project structure
2. Customize templates for your domain
3. Modify commands for your workflow
4. Extend MCP server for additional features

## License

This implementation is provided as a reference for spec-driven development with Claude Code. Adapt and modify as needed for your projects.

---

*Generated with Claude Code - Spec-Driven Development Implementation*
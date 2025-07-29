# Deployment Guide

## 🚀 Agent-Powered Installation System

This spec-driven development system uses AI agents and orchestrated workflows that users can install with a single command.

## Installation Options for Users

### 1. Quick Install (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/quick-install.sh | bash
```
- **Fast**: Minimal output, essential files only
- **Smart**: Skips existing files, detects project type
- **Safe**: Checks dependencies, handles errors gracefully

### 2. Full Featured Install
```bash
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/install.sh | bash
```
- **Comprehensive**: Detailed progress, system detection
- **Interactive**: Asks about existing setups, creates backups
- **Robust**: Full verification, dependency management
- **Informative**: Complete setup guide and next steps

### 3. Manual Install
```bash
git clone https://github.com/your-username/claude-code-sdd.git
cp -r claude-code-sdd/.claude /path/to/your/project/
cp -r claude-code-sdd/specs /path/to/your/project/
chmod +x /path/to/your/project/.claude/hooks/*.sh
```

## What Gets Installed

### Core Components
- **5 Orchestrated Slash Commands** (`/cc-sdd/spec`, `/cc-sdd/requirements`, `/cc-sdd/design`, `/cc-sdd/task`, `/cc-sdd/start-task`)
- **3 Specialized AI Agents** (requirements-specialist, design-architect, task-planner)
- **State Management Files** (PROJECT_STATE.md, WORKFLOW_CONTEXT.md)
- **Generated Specifications** (REQUIREMENTS.md, DESIGN.md, TASK.md)
- **Configuration** (Claude Code settings with agent permissions)

### Directory Structure Created
```
your-project/
├── .claude/
│   ├── PROJECT_STATE.md    # Workflow status tracking
│   ├── WORKFLOW_CONTEXT.md # Agent coordination context
│   ├── agents/             # Specialized AI agents
│   │   ├── requirements-specialist.md
│   │   ├── design-architect.md
│   │   └── task-planner.md
│   ├── commands/cc-sdd/    # Namespaced slash commands
│   │   ├── spec.md
│   │   ├── requirements.md
│   │   ├── design.md
│   │   ├── task.md
│   │   └── start-task.md
│   └── settings.local.json # Agent permissions configuration
├── specs/                  # AI-generated specifications
│   ├── REQUIREMENTS.md     # EARS-format requirements
│   ├── DESIGN.md           # Technical architecture
│   └── TASK.md             # Structured task breakdown
├── CLAUDE.md               # Project overview and metadata (standard Claude Code context file)
└── .gitignore              # Updated with spec-related entries
```

## Deployment Requirements

### To Host This System
1. **GitHub Repository**: Host the files with public access
2. **Update URLs**: Replace `your-username` with actual GitHub username
3. **Test Installation**: Run `./test-install.sh` to verify

### Repository Setup
```bash
# Create repository
git init
git add .
git commit -m "Initial commit: Spec-driven development system"
git remote add origin https://github.com/your-username/claude-code-sdd.git
git push -u origin main
```

### URL Updates Needed
Replace in all installer files:
- `your-username` → actual GitHub username
- `claude-code-sdd` → actual repository name

## Testing

### Local Testing
```bash
./test-install.sh
```
This creates a temporary environment and verifies:
- All files install correctly
- Hooks are executable and functional
- Directory structure is proper
- Commands have valid structure

### Real Project Testing
```bash
# In a test project
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/quick-install.sh | bash
claude /cc-sdd/spec "Test project"
```

## Features of the Installation System

### 🔍 Smart Detection
- **Project Type**: Recognizes Node.js, Python, Rust, Go, Java projects
- **Existing Setup**: Detects current Claude Code configuration
- **Dependencies**: Automatically installs MCP SDK for Node.js projects
- **Operating System**: Adapts to Linux, macOS, Windows (Git Bash)

### 🛡️ Safety Features
- **Backup Protection**: Creates backups of existing `.claude` setups
- **Non-destructive**: Won't overwrite existing specification files
- **Error Handling**: Graceful failure with helpful error messages
- **Verification**: Tests installation completeness before finishing

### ⚡ Performance
- **Agent Coordination**: Efficient sequential processing with state preservation
- **Minimal Dependencies**: Only requires `curl` and basic shell tools
- **Fast Execution**: Quick install completes in ~10 seconds
- **Progress Feedback**: Clear status updates during installation

### 🎯 User Experience
- **One Command**: Single curl command for complete agent-powered setup
- **Interactive Approval**: Each document presented for user review before saving
- **Intelligent Workflow**: AI agents handle specification generation automatically
- **Clear Output**: Color-coded status messages and progress
- **Agent Coordination**: Seamless requirements → design → tasks workflow
- **Context Awareness**: WORKFLOW_CONTEXT.md maintains session continuity

## Customization

### For Different Domains
Modify these files before deployment:
- `specs/*.md` - Update templates for your domain
- `.claude/commands/cc-sdd/*.md` - Adjust prompts and questions
- `.claude/settings.local.json` - Configure permissions and prompts

### For Organizations
- Fork the repository
- Customize templates and commands
- Update branding and examples
- Deploy to internal repositories
- Add organization-specific integrations

## Maintenance

### Updates
- Modify source files in the repository
- Test with `./test-install.sh`
- Push changes to GitHub
- Users get updates on next install

### Versioning
- Tag releases: `git tag v1.0.0`
- Update version numbers in installers
- Maintain backward compatibility
- Document breaking changes

## Support

### Common Issues
1. **Command Not Found**: Ensure commands are in `.claude/commands/cc-sdd/` directory
2. **Files Not Created**: Check that user approved document saving during workflow
3. **Agent Not Found**: Verify agents are in `.claude/agents/` directory
4. **Permission Issues**: Ensure proper file permissions for Claude Code

### Troubleshooting
```bash
# Verify installation
claude /cc-sdd/spec "Test project"

# Check command structure
ls -la .claude/commands/cc-sdd/

# Verify agent availability
ls -la .claude/agents/

# Check generated specifications
ls -la specs/
```

## Success Metrics

The installation system provides:
- **Zero-friction adoption**: Single command setup
- **High success rate**: Comprehensive error handling and verification
- **Fast onboarding**: Users productive in minutes, not hours
- **Consistent setup**: Identical configuration across all projects
- **Easy maintenance**: Centralized updates through GitHub

This automated installation system makes spec-driven development with Claude Code accessible to any developer with a single command, removing all barriers to adoption.

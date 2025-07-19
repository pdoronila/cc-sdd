# Deployment Guide

## 🚀 Automated Installation System Complete!

This spec-driven development system now includes comprehensive automated installation that users can run with a single command.

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
- **5 Custom Slash Commands** (`/spec-init`, `/spec-validate`, `/spec-update`, `/spec-tasks`, `/spec-review`)
- **2 Automation Hooks** (pre-commit validation, post-edit sync)
- **1 MCP Server** (advanced spec synchronization)
- **4 Specification Templates** (requirements, design, tasks, api-spec)
- **Configuration** (Claude Code settings with permissions and prompts)

### Directory Structure Created
```
your-project/
├── .claude/
│   ├── commands/           # 5 slash commands (.md files)
│   ├── hooks/             # 2 automation scripts (.sh files)
│   ├── mcp-servers/       # MCP server for advanced features
│   └── settings.local.json # Claude Code configuration
├── specs/
│   ├── requirements.md    # EARS format user stories
│   ├── design.md         # Technical architecture
│   ├── tasks.md          # Implementation planning
│   └── api-spec.md       # API documentation
└── .gitignore            # Updated with spec-related entries
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
claude /spec-init
claude /spec-validate
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
- **Parallel Downloads**: Efficient file retrieval
- **Minimal Dependencies**: Only requires `curl` and basic shell tools
- **Fast Execution**: Quick install completes in ~10 seconds
- **Progress Feedback**: Clear status updates during installation

### 🎯 User Experience
- **One Command**: Single curl command for complete setup
- **Guided Setup**: Interactive prompts for existing configurations
- **Clear Output**: Color-coded status messages and progress
- **Next Steps**: Comprehensive guide after installation
- **Documentation**: Embedded help and examples

## Customization

### For Different Domains
Modify these files before deployment:
- `specs/*.md` - Update templates for your domain
- `.claude/commands/*.md` - Adjust prompts and questions
- `.claude/hooks/*.sh` - Add domain-specific validations
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
1. **Permission Denied**: Run `chmod +x .claude/hooks/*.sh`
2. **Command Not Found**: Ensure files have `.md` extension
3. **MCP Server Fails**: Install Node.js and run `npm install @modelcontextprotocol/sdk`
4. **Hooks Don't Run**: Check Claude Code hook configuration

### Troubleshooting
```bash
# Verify installation
claude /spec-validate

# Test hooks manually
./.claude/hooks/validate-specs.sh

# Check file permissions
ls -la .claude/hooks/

# Validate command structure
grep -r "spec-init" .claude/commands/
```

## Success Metrics

The installation system provides:
- **Zero-friction adoption**: Single command setup
- **High success rate**: Comprehensive error handling and verification
- **Fast onboarding**: Users productive in minutes, not hours
- **Consistent setup**: Identical configuration across all projects
- **Easy maintenance**: Centralized updates through GitHub

This automated installation system makes spec-driven development with Claude Code accessible to any developer with a single command, removing all barriers to adoption.
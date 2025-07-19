# Installation Guide

## Quick Install

### 1. Copy Core Files
Copy these directories to your project:

```bash
# From this repository to your project
cp -r .claude/ /path/to/your/project/
cp -r specs/ /path/to/your/project/
```

### 2. Make Scripts Executable
```bash
cd /path/to/your/project
chmod +x .claude/hooks/*.sh
```

### 3. Install MCP Dependencies (Optional)
```bash
npm install @modelcontextprotocol/sdk
```

## Manual Installation

### Step 1: Create Directory Structure
```bash
mkdir -p .claude/commands .claude/hooks .claude/mcp-servers specs
```

### Step 2: Copy Command Files
Copy these files from `.claude/commands/`:
- `spec-init.md`
- `spec-validate.md` 
- `spec-update.md`
- `spec-tasks.md`
- `spec-review.md`

### Step 3: Copy Hook Scripts
Copy these files from `.claude/hooks/`:
- `validate-specs.sh`
- `sync-specs.sh`

Make them executable:
```bash
chmod +x .claude/hooks/*.sh
```

### Step 4: Copy Configuration
Copy `.claude/settings.local.json` and adjust paths if needed.

### Step 5: Copy Specification Templates
Copy these template files from `specs/`:
- `requirements.md`
- `design.md`
- `tasks.md` 
- `api-spec.md`

### Step 6: Copy MCP Server (Optional)
Copy `.claude/mcp-servers/spec-sync-server.js` for advanced features.

## Automated Installation Script

Create an install script for easy setup:

```bash
#!/bin/bash
# install-sdd.sh

set -e

echo "🚀 Installing Spec-Driven Development for Claude Code..."

# Check if we're in a valid project directory
if [ ! -f "package.json" ] && [ ! -f "pyproject.toml" ] && [ ! -f "Cargo.toml" ]; then
    echo "⚠️  Warning: No project manifest found. Continue anyway? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 1
    fi
fi

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p .claude/commands .claude/hooks .claude/mcp-servers specs

# Function to download file from GitHub
download_file() {
    local source_path=$1
    local dest_path=$2
    local base_url="https://raw.githubusercontent.com/your-org/claude-code-sdd/main"
    
    if command -v curl >/dev/null 2>&1; then
        curl -sL "$base_url/$source_path" -o "$dest_path"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$base_url/$source_path" -O "$dest_path"
    else
        echo "❌ Error: curl or wget required for download"
        exit 1
    fi
}

# Install command files
echo "📝 Installing slash commands..."
commands=("spec-init.md" "spec-validate.md" "spec-update.md" "spec-tasks.md" "spec-review.md")
for cmd in "${commands[@]}"; do
    download_file ".claude/commands/$cmd" ".claude/commands/$cmd"
    echo "  ✅ $cmd"
done

# Install hook scripts
echo "🔗 Installing hooks..."
hooks=("validate-specs.sh" "sync-specs.sh")
for hook in "${hooks[@]}"; do
    download_file ".claude/hooks/$hook" ".claude/hooks/$hook"
    chmod +x ".claude/hooks/$hook"
    echo "  ✅ $hook"
done

# Install configuration
echo "⚙️  Installing configuration..."
download_file ".claude/settings.local.json" ".claude/settings.local.json"

# Install specification templates
echo "📋 Installing specification templates..."
specs=("requirements.md" "design.md" "tasks.md" "api-spec.md")
for spec in "${specs[@]}"; do
    if [ ! -f "specs/$spec" ]; then
        download_file "specs/$spec" "specs/$spec"
        echo "  ✅ $spec"
    else
        echo "  ⏭️  $spec (already exists)"
    fi
done

# Install MCP server (optional)
echo "🌐 Installing MCP server..."
download_file ".claude/mcp-servers/spec-sync-server.js" ".claude/mcp-servers/spec-sync-server.js"

# Install npm dependencies if package.json exists
if [ -f "package.json" ]; then
    echo "📦 Installing MCP dependencies..."
    npm install @modelcontextprotocol/sdk --save-dev
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Next steps:"
echo "1. Run: claude /spec-init"
echo "2. Follow the prompts to set up your specifications"
echo "3. Use claude /spec-validate to check your setup"
echo ""
echo "Available commands:"
echo "  /spec-init     - Initialize project specifications"
echo "  /spec-validate - Validate specification consistency"
echo "  /spec-update   - Update specs from codebase"
echo "  /spec-tasks    - Generate implementation tasks"
echo "  /spec-review   - Review spec-code alignment"
echo ""
echo "For more information, see: https://github.com/your-org/claude-code-sdd"
```

## Git-based Installation

### Option A: Git Subtree (Recommended)
```bash
# Add as subtree (maintains history)
git subtree add --prefix=sdd-template https://github.com/your-org/claude-code-sdd.git main --squash

# Copy files to project root
cp -r sdd-template/.claude .
cp -r sdd-template/specs .
chmod +x .claude/hooks/*.sh

# Remove template directory
rm -rf sdd-template
```

### Option B: Git Submodule
```bash
# Add as submodule
git submodule add https://github.com/your-org/claude-code-sdd.git sdd-template

# Copy files to project root
cp -r sdd-template/.claude .
cp -r sdd-template/specs .
chmod +x .claude/hooks/*.sh
```

### Option C: Direct Download
```bash
# Download and extract
curl -L https://github.com/your-org/claude-code-sdd/archive/main.zip -o sdd.zip
unzip sdd.zip
cp -r claude-code-sdd-main/.claude .
cp -r claude-code-sdd-main/specs .
chmod +x .claude/hooks/*.sh
rm -rf claude-code-sdd-main sdd.zip
```

## NPM Package Installation

Create an npm package for easy distribution:

### Package Structure
```
claude-code-sdd/
├── package.json
├── bin/
│   └── install-sdd.js
├── templates/
│   ├── .claude/
│   └── specs/
└── README.md
```

### Install Command
```bash
npx claude-code-sdd init
```

### Package.json
```json
{
  "name": "claude-code-sdd",
  "version": "1.0.0",
  "description": "Spec-driven development templates for Claude Code",
  "bin": {
    "claude-sdd": "./bin/install-sdd.js"
  },
  "files": [
    "bin/",
    "templates/"
  ]
}
```

## Customization After Installation

### 1. Adjust Templates
Modify files in `specs/` to match your domain:
- Update section headers
- Add domain-specific examples
- Customize validation rules

### 2. Configure Commands
Edit files in `.claude/commands/` to:
- Change discovery questions
- Adjust validation criteria
- Add domain-specific prompts

### 3. Customize Hooks
Modify `.claude/hooks/` scripts to:
- Add project-specific validations
- Change sync triggers
- Integrate with existing tools

### 4. Update Settings
Edit `.claude/settings.local.json` to:
- Adjust permissions
- Configure MCP servers
- Set custom prompts

## Verification

After installation, verify everything works:

```bash
# Test slash commands
claude /spec-validate

# Test hooks
./.claude/hooks/validate-specs.sh

# Check MCP server (if installed)
node .claude/mcp-servers/spec-sync-server.js --help
```

## Troubleshooting

### Permission Issues
```bash
chmod +x .claude/hooks/*.sh
```

### Missing Dependencies
```bash
npm install @modelcontextprotocol/sdk
```

### Path Issues
Update paths in `.claude/settings.local.json` if files are in different locations.

### Command Not Found
Ensure `.claude/commands/` files have `.md` extension and proper format.

## Integration with Existing Projects

### For Existing Documentation
- Migrate existing docs into spec templates
- Map current requirements to EARS format
- Update task tracking to use new templates

### For Teams
- Schedule training session on spec-driven development
- Establish review processes using new commands
- Set up CI/CD integration with validation hooks

### For Different Languages/Frameworks
- Customize API templates for your stack
- Adjust file detection patterns in hooks
- Add framework-specific validation rules
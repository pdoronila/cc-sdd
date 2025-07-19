# Spec-Driven Development for Claude Code

A hook-free implementation of spec-driven development workflows using Claude Code's custom slash commands. Zero interference with team workflows, maximum productivity.

## Overview

This project provides a complete spec-driven development system that prioritizes creating detailed specifications before writing code. The hook-free approach ensures no interference with other developers while providing powerful automation through inline command logic.

**Key Principles:**
- 📋 **Specification First** - Plan before coding
- 🔗 **Requirement Traceability** - Every task links to business needs  
- 🚀 **Frictionless Workflow** - 2-command development cycle
- 🤝 **Team Friendly** - Zero interference, no background processes
- ⚡ **Inline Automation** - Quality gates and state management built into commands

## Features

### 🔧 Streamlined 5-Command System

#### **Setup Phase (Once per project)**
- **`/spec-init`** - Initialize project specifications with guided setup
- **`/spec-tasks`** - Generate implementation tasks from requirements with full traceability

#### **Quality Assurance**
- **`/spec-validate`** - Validate specifications, requirement traceability, and consistency

#### **Development Cycle (Repeated)**
- **`/spec-work`** - Auto-select next task and start implementation ⭐
- **`/spec-done`** - Complete task with quality gates + start next task ⭐

### 🎯 Hook-Free Benefits

- **Zero Interference** - No hooks, no background processes, won't affect other developers
- **Team Friendly** - Install and use without impacting anyone else's workflow
- **Self-Contained** - All logic embedded in slash commands, fully transparent
- **Portable** - Works in any environment without complex setup
- **Reliable** - No hidden dependencies or automatic triggers

### 📊 Emoji-Based Task States

Visual progress tracking directly in `specs/tasks.md`:

- ⚪ **Empty** - Not started (default state)
- 🔄 **Started** - Currently being worked on  
- 🎉 **Done** - Completed and validated

Commands automatically update these symbols to show real-time progress.

### 🔗 Requirement Traceability

Every task links to specific requirements:

```markdown
- [ ] ⚪ **Task 2.1**: Implement User Authentication
  - **Description**: JWT-based authentication system
  - **Estimated Effort**: 8 hours
  - **Dependencies**: Task 1.3
  - **Files**: auth.service.js, auth.controller.js
  - _Requirements: REQ-1.1, REQ-1.2, FR-3, NFR-4_
```

**Traceability System:**
- **REQ-X.Y** - User stories from requirements.md
- **FR-X** - Functional requirements
- **NFR-X** - Non-functional requirements (performance, security, etc.)

### ⚡ Inline Quality Gates

Built-in validation with multi-language support:

- **Compilation** - Build/compile checks
- **Testing** - Full test suite execution
- **Code Quality** - Linting with auto-fixes
- **Formatting** - Automatic code formatting
- **Type Safety** - Type checking (when applicable)

**Supported Languages:**
- Node.js/TypeScript, Python, Rust, Go, Java, Elixir/Phoenix

## Quick Start

### 1. Installation

```bash
# One-line install (recommended)
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/quick-install.sh | bash

# Or full install with all options
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/install.sh | bash
```

### 2. Initialize Your Project

```bash
claude /spec-init
```

**This creates:**
- `specs/requirements.md` - User stories and requirements with unique IDs
- `specs/design.md` - Technical architecture and design decisions  
- `specs/tasks.md` - Implementation tasks with emoji-based progress
- `specs/api-spec.md` - API documentation (if applicable)

### 3. Generate Implementation Tasks

```bash
claude /spec-tasks
```

**This analyzes your requirements and creates:**
- Prioritized task breakdown
- Effort estimates and dependencies
- Complete requirement traceability links
- Ready-to-implement work items

### 4. Start Development Cycle

```bash
# Start working
claude /spec-work     # Auto-selects next task (⚪ → 🔄)
# ... implement the task ...
claude /spec-done     # Validates quality + marks done (🔄 → 🎉) + starts next

# Continue seamlessly  
claude /spec-done     # Complete next task + start another
claude /spec-done     # Repeat for continuous flow...
```

## Development Workflow

### 🚀 The Complete Cycle

```bash
# One-time setup
claude /spec-init      # Create specifications
claude /spec-tasks     # Generate tasks with traceability

# Continuous development loop
claude /spec-work      # ⚪ → 🔄 (select and start next task)
# ... write code, run tests locally ...
claude /spec-done      # 🔄 → 🎉 (quality validation + completion + next task)

# Repeat /spec-done for continuous momentum!
```

### ⚡ What Happens During `/spec-done`

1. **Find Current Task** - Scans specs/tasks.md for 🔄 (started) tasks
2. **Quality Validation** - Runs inline checks:
   - Detects project type (package.json, requirements.txt, etc.)
   - Executes compile/build commands
   - Runs full test suite
   - Checks and auto-fixes linting/formatting
   - Validates types (if applicable)
3. **Update Status** - Based on validation results:
   - ✅ **Quality Pass**: 🔄 → 🎉 + auto-start next task
   - ❌ **Quality Fail**: Keep 🔄 + show specific issues to fix

### 🔍 Quality Assurance

```bash
claude /spec-validate
```

**Validates:**
- Specification completeness and consistency
- Requirement traceability (orphaned requirements, unlinked tasks)
- Cross-document alignment
- EARS format compliance
- Coverage analysis

## Project Structure

```
project/
├── specs/                          # Specification documents
│   ├── requirements.md             # User stories and requirements (REQ-X.Y, FR-X, NFR-X)
│   ├── design.md                   # Technical architecture and decisions
│   ├── tasks.md                    # Implementation tasks with emoji states
│   └── api-spec.md                 # API documentation (optional)
├── .claude/                        # Claude Code configuration  
│   ├── commands/                   # 5 custom slash commands
│   │   ├── spec-init.md            # Project initialization
│   │   ├── spec-tasks.md           # Task generation with traceability
│   │   ├── spec-validate.md        # Validation and consistency
│   │   ├── spec-work.md            # Start next task
│   │   └── spec-done.md            # Complete with quality gates
│   ├── utils/                      # Optional manual utilities
│   │   ├── validate-specs.sh       # Manual validation
│   │   ├── sync-specs.sh           # Manual sync
│   │   ├── quality-check.sh        # Manual quality check
│   │   └── task-state-manager.sh   # Manual state management
│   ├── mcp-servers/                # Optional MCP integration
│   │   └── spec-sync-server.js     # Advanced sync features
│   └── settings.local.json         # Hook-free configuration
└── [your implementation files]
```

## Advanced Features

### 📋 Specification Templates

#### EARS Format Requirements
```markdown
#### REQ-1.1: User Login
**WHEN** a user enters valid credentials  
**THE SYSTEM SHALL** authenticate and redirect to dashboard  
**WHERE** authentication server is available

**Acceptance Criteria:**
- [ ] Login form validates email format
- [ ] Password must be 8+ characters
- [ ] Invalid credentials show error message
- [ ] Successful login redirects to dashboard

**Priority**: High
**Requirements**: REQ-1.1, FR-2, NFR-4
```

#### Task with Traceability
```markdown
- [ ] ⚪ **Task 1.2**: Implement Login Form
  - **Description**: React component with validation
  - **Estimated Effort**: 4 hours
  - **Dependencies**: Task 1.1  
  - **Files**: Login.tsx, Login.test.tsx, auth.service.ts
  - _Requirements: REQ-1.1, FR-2, NFR-4_
```

### 🔧 Optional Utilities

Manual tools available in `.claude/utils/`:

```bash
# Run manually when needed (no automatic execution)
./.claude/utils/validate-specs.sh     # Validate specifications
./.claude/utils/sync-specs.sh         # Sync specs with code
./.claude/utils/quality-check.sh      # Manual quality validation
./.claude/utils/task-state-manager.sh # Manual task state management
```

### 🌐 MCP Server (Optional)

Advanced capabilities for power users:

- **Drift Detection** - Identify spec-code divergence
- **Consistency Validation** - Cross-document alignment
- **Traceability Matrix** - Requirements coverage analysis
- **Coverage Metrics** - Implementation completeness

## Team Collaboration

### 🤝 Zero Interference Approach

- **No Hooks** - Won't trigger on commits or file changes
- **No Background Processes** - All actions are explicit and visible
- **Individual Choice** - Each developer can use or ignore the system
- **Shared Benefits** - Specifications benefit everyone, automation is optional

### 👥 Best Practices

1. **Collaborative Spec Writing** - Team reviews requirements and design
2. **Individual Implementation** - Developers use `/spec-work` and `/spec-done` as desired
3. **Regular Validation** - Team runs `/spec-validate` before major milestones
4. **Living Documentation** - Specifications stay current with implementation

## Installation Options

### 🚀 Quick Install
```bash
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/quick-install.sh | bash
```

### 📦 Full Install  
```bash
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-sdd/main/install.sh | bash
```

### 🔧 Local Development Install
```bash
# From cloned repository directory
git clone https://github.com/your-username/claude-code-sdd.git
cd /path/to/your/project/
../claude-code-sdd/install-local-copy.sh
```

### 📋 Manual Install
```bash
git clone https://github.com/your-username/claude-code-sdd.git
cp -r claude-code-sdd/.claude /path/to/your/project/
cp -r claude-code-sdd/specs /path/to/your/project/
chmod +x /path/to/your/project/.claude/utils/*.sh
```

### ✅ Verify Installation
```bash
claude /spec-validate   # Test command availability
./.claude/utils/validate-specs.sh  # Test utilities
```

## Benefits

### For Developers
- **Clear Direction** - Always know what to work on next
- **Quality Confidence** - Automated validation prevents regressions  
- **Reduced Context Switching** - Seamless task transitions
- **No Workflow Disruption** - Hook-free approach respects individual preferences

### For Teams
- **Shared Understanding** - Comprehensive specifications reduce miscommunication
- **Progress Visibility** - Emoji states show real-time progress
- **Requirement Traceability** - Track business needs through implementation
- **Flexible Adoption** - Use as much or as little as desired

### For Projects
- **Better Planning** - Detailed task breakdown improves estimates
- **Living Documentation** - Specifications evolve with implementation
- **Quality Assurance** - Built-in validation prevents technical debt
- **Onboarding** - New team members understand system design quickly

## Contributing

This is a reference implementation designed to be forked and customized:

1. **Fork the Structure** - Copy and adapt for your domain
2. **Customize Templates** - Modify specs/ for your requirements format
3. **Extend Commands** - Add domain-specific slash commands
4. **Share Improvements** - Contribute back useful enhancements

## License

Reference implementation for spec-driven development with Claude Code. 
Adapt and modify freely for your projects.

---

*🚀 Hook-Free Spec-Driven Development - Zero Interference, Maximum Productivity*
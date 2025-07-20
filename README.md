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
- **`/spec-init`** - Intelligent project initialization with automatic codebase detection ⭐
  - **New Projects**: Interactive requirements gathering and fresh specification generation
  - **Existing Projects**: Reverse engineering, documentation, and systematic improvement planning

#### **Feature Development**
- **`/spec-feat`** - Add new features to specifications with interactive refinement ⭐

#### **Quality Assurance**
- **`/spec-validate`** - Validate specifications, requirement traceability, and consistency

#### **Development Cycle (Repeated)**
- **`/spec-work`** - Auto-select next task and start implementation ⭐
- **`/spec-done`** - Complete task with quality gates + start next task ⭐

### 🔍 Intelligent Project Detection

Automatically adapts to your development context:

#### **🆕 New Projects (Greenfield Mode)**
- Interactive discovery and requirements gathering
- Fresh specification generation from user input
- Technology stack planning and architecture design
- Complete implementation roadmap creation

#### **🔄 Existing Projects (Retrofit Mode)**
- **Automatic Detection**: Recognizes Node.js, Python, Go, Rust, Elixir/Phoenix, and more
- **Codebase Analysis**: Reverse engineers API endpoints, data models, and business logic
- **Documentation Generation**: Creates specs from existing implementations
- **Gap Analysis**: Identifies technical debt and improvement opportunities
- **Systematic Planning**: Prioritizes documentation → technical debt → enhancements

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

**Automatically detects and adapts to your project:**

#### **🆕 New Projects (Greenfield)**
- Interactive discovery and requirements gathering
- Complete specification generation from scratch
- Technology stack planning and architecture design
- Fresh implementation roadmap

#### **🔄 Existing Projects (Retrofit)**
- Automatic codebase analysis and reverse engineering
- Documentation of current functionality and architecture
- Identification of technical debt and improvement opportunities
- Systematic enhancement planning

**Creates complete project specifications:**
- `specs/requirements.md` - User stories and requirements with unique IDs
- `specs/design.md` - Technical architecture and design decisions  
- `specs/tasks.md` - Implementation tasks with emoji-based progress and full traceability
- `specs/api-spec.md` - API documentation (if applicable)

**Includes intelligent task breakdown:**
- **New Projects**: Feature development with sprint organization
- **Existing Projects**: Documentation → Technical Debt → Enhancements → Quality
- Complete requirement traceability (REQ-X.Y, FR-X, NFR-X links)
- Ready-to-implement work items with priority-based sequencing

### 3. Start Development Cycle

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
claude /spec-init      # Complete specifications with tasks and traceability

# Add new features (as needed)
claude /spec-feat "New feature description"  # Interactive feature specification

# Continuous development loop
claude /spec-work      # ⚪ → 🔄 (select and start next task)
# ... write code, run tests locally ...
claude /spec-done      # 🔄 → 🎉 (quality validation + completion + next task)

# Repeat /spec-done for continuous momentum!
```

### 📊 Visual Workflow

```
                    ┌─────────────────┐
                    │   /spec-init    │
                    │ Auto-Detection  │
                    └─────────┬───────┘
                              │
                    ┌─────────▼────────┐
                    │   Project Type?   │
                    └─────┬──────┬─────┘
                          │      │
            ┌─────────────▼─┐  ┌─▼──────────────┐
            │ 🆕 Greenfield │  │ 🔄 Existing    │
            │ Requirements  │  │ Code Analysis  │
            │ Gathering     │  │ & Reverse Eng. │
            └─────────────┬─┘  └─┬──────────────┘
                          │      │
                    ┌─────▼──────▼─────┐
                    │  Generate Specs  │
                    │ • requirements   │
                    │ • design         │
                    │ • api-spec       │
                    │ • tasks          │
                    └─────────┬────────┘
                              │
              ┌───────────────▼────────────────┐
              │         Development Flow        │
              └─────────────┬───────────────────┘
                            │
    ┌───────────────────────▼────────────────────────┐
    │                 Daily Workflow                 │
    │                                                │
    │  /spec-feat ──► Add new feature specs         │
    │       │                                        │
    │       ▼                                        │
    │  /spec-work ──► ⚪ → 🔄 Select & start task    │
    │       │                                        │
    │       ▼                                        │
    │  Code & Test ──► Write implementation          │
    │       │                                        │
    │       ▼                                        │
    │  /spec-done ──► 🔄 → 🎉 Quality gates + next  │
    │       │                                        │
    │       └───────► Loop back to /spec-work        │
    │                                                │
    │  /spec-validate ──► Check consistency          │
    └────────────────────────────────────────────────┘
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

#### **For New Projects**
1. **Team Spec Writing** - Collaborative requirements gathering and design sessions
2. **Individual Implementation** - Developers use `/spec-work` and `/spec-done` workflow
3. **Regular Validation** - Team runs `/spec-validate` before major milestones
4. **Living Documentation** - Specifications evolve with implementation

#### **For Existing Projects**
1. **Gradual Adoption** - Start with `/spec-init` to document current state
2. **Systematic Documentation** - Use generated tasks to document critical features
3. **Technical Debt Management** - Address high-priority gaps systematically
4. **Feature Enhancement** - Use `/spec-feat` for new functionality
5. **Knowledge Sharing** - Generated specs help with team onboarding

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
- **Clear Direction** - Always know what to work on next with prioritized task queues
- **Quality Confidence** - Automated validation prevents regressions  
- **Reduced Context Switching** - Seamless task transitions with workflow automation
- **No Workflow Disruption** - Hook-free approach respects individual preferences
- **Legacy Understanding** - Reverse-engineered specs help understand existing codebases

### For Teams
- **Universal Adoption** - Works with new projects AND existing codebases
- **Shared Understanding** - Comprehensive specifications reduce miscommunication
- **Progress Visibility** - Emoji states show real-time progress across all work
- **Requirement Traceability** - Track business needs through implementation
- **Systematic Improvement** - Organized approach to technical debt and enhancements
- **Flexible Adoption** - Use as much or as little as desired

### For Projects
- **Better Planning** - Detailed task breakdown improves estimates
- **Living Documentation** - Specifications evolve with implementation
- **Quality Assurance** - Built-in validation prevents technical debt
- **Rapid Onboarding** - New team members understand system design quickly
- **Legacy Modernization** - Systematic approach to improving existing systems
- **Technical Debt Management** - Prioritized roadmap for improvements

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
# Spec-Driven Development for Claude Code

An agent-powered spec-driven development system using Claude Code's specialized agents and custom slash commands. Zero interference with team workflows, maximum productivity through intelligent automation.

## Overview

This project provides a complete spec-driven development system that prioritizes creating detailed specifications before writing code. The hook-free approach ensures no interference with other developers while providing powerful automation through inline command logic.

**Key Principles:**
- 📋 **Specification First** - Plan before coding with EARS-format requirements
- 🤖 **Agent-Powered** - Specialized AI agents for requirements, design, and task planning
- 🔗 **Requirement Traceability** - Every task links to business needs
- 🚀 **Streamlined Workflow** - 4-command orchestrated development cycle
- 🤝 **Team Friendly** - Zero interference, no background processes
- ⚡ **Intelligent Automation** - AI agents handle specification generation and management

## Features

### 🤖 Agent-Powered 4-Command System

**Specialized AI Agents:**
- **Requirements Specialist** - EARS-format requirements generation
- **Design Architect** - Technical architecture and component design
- **Task Planner** - Development task breakdown with dependencies

#### **Complete Workflow Commands**
- **`/cc-sdd/spec`** - Master orchestrator that runs all phases ⭐
  - Generates requirements, design, and tasks in sequence with user approval
  - Uses specialized agents for each phase
  - Interactive refinement loop - review and approve each document
  - Creates complete project specifications

#### **Individual Phase Commands**
- **`/cc-sdd/requirements`** - Generate/refine EARS-format requirements ⭐
- **`/cc-sdd/design`** - Create technical architecture and design ⭐
- **`/cc-sdd/task`** - Break down into actionable development tasks ⭐
- **`/cc-sdd/start-task`** - Integrate all specs into comprehensive todo planning ⭐

### 🤖 AI Agent Architecture

Three specialized agents handle different aspects of specification:

#### **Requirements Specialist Agent**
- **EARS Format Expert**: Creates precise, testable requirements
- **Pattern Recognition**: Ubiquitous, Event-Driven, State-Driven, Optional, Unwanted Behavior
- **Quality Assurance**: Ensures atomic, testable requirements with clear acceptance criteria
- **Tools**: Read, Write, WebSearch for comprehensive requirement analysis

#### **Design Architect Agent**
- **Technical Architecture**: Translates requirements into actionable technical designs
- **Component Design**: Defines system boundaries, interfaces, and data flow
- **Technology Selection**: Chooses appropriate frameworks, patterns, and tools
- **Tools**: Read, Write, Bash (directory analysis), WebSearch for architecture research

#### **Task Planner Agent**
- **Task Breakdown**: Converts design into implementable development tasks
- **Dependency Management**: Identifies task dependencies and optimal sequencing
- **Complexity Estimation**: Assigns effort estimates (S/M/L/XL) and priorities (P0/P1/P2)
- **Tools**: Read, Write, Bash (git integration) for project state management

### 🎯 Hook-Free Benefits

- **Zero Interference** - No hooks, no background processes, won't affect other developers
- **Team Friendly** - Install and use without impacting anyone else's workflow
- **Self-Contained** - All logic embedded in slash commands, fully transparent
- **Portable** - Works in any environment without complex setup
- **Reliable** - No hidden dependencies or automatic triggers

### 📊 Structured Task Management

Task breakdown with comprehensive metadata in `specs/TASK.md`:

```markdown
- [ ] [TASK-001] Component Implementation
  - **Complexity**: M (Small/Medium/Large/XL)
  - **Priority**: P0 (P0/P1/P2)
  - **Dependencies**: TASK-002
  - **Requirements**: REQ-001, REQ-010
  - **Files**: src/components/component.js
```

Agent-generated tasks include full traceability and project context.

### 🔗 EARS-Format Requirements

Precise, testable requirements using EARS patterns:

```markdown
#### REQ-001 (Ubiquitous)
The system shall authenticate users via JWT tokens

#### REQ-010 (Event-Driven)
When a user submits login credentials, the system shall validate and return a JWT token

#### REQ-020 (State-Driven)
While a user session is active, the system shall authorize API requests

#### REQ-030 (Optional)
Where two-factor authentication is enabled, the system shall require secondary verification

#### REQ-040 (Unwanted Behavior)
If authentication fails, then the system shall return a 401 error with rate limiting
```

**EARS Patterns:**
- **Ubiquitous** - Always active system behavior
- **Event-Driven** - Response to specific triggers
- **State-Driven** - Conditional behavior based on system state
- **Optional** - Feature-dependent functionality
- **Unwanted Behavior** - Error handling and edge cases

### ⚡ Workflow Context Management

Automated state tracking and document synchronization:

- **PROJECT_STATE.md** - Tracks workflow progress and generated artifacts
- **.claude/WORKFLOW_CONTEXT.md** - Maintains session context across agent interactions
- **Phase Coordination** - Ensures requirements → design → tasks flow
- **Document Validation** - Verifies completeness and consistency
- **Git Integration** - Commits specifications at each phase

**Agent Coordination:**
- Each agent reads previous phase outputs
- Master orchestrator manages phase transitions
- Context preservation across multi-step workflows

## Quick Start

### 1. Installation

```bash
# One-line install
curl -sSL https://raw.githubusercontent.com/pdoronila/cc-sdd/refs/heads/main/quick-install.sh | bash
```

### 2. Generate Complete Specifications

```bash
claude /cc-sdd/spec "Your project description here"
```

**AI-Powered Specification Generation:**

#### **🤖 Agent Orchestration**
- Requirements Specialist creates EARS-format requirements
- Design Architect develops technical architecture
- Task Planner breaks down into actionable tasks
- Master orchestrator coordinates the complete workflow

#### **📋 Generated Specifications**
- `CLAUDE.md` - Project overview and metadata (standard Claude Code context file)
- `specs/REQUIREMENTS.md` - EARS-format functional requirements
- `specs/DESIGN.md` - Technical architecture and component design
- `specs/TASK.md` - Structured task breakdown with dependencies
- `.claude/WORKFLOW_CONTEXT.md` - Session context and agent coordination

#### **🔄 Individual Phase Refinement**
```bash
claude /cc-sdd/requirements "Additional feature requirements"
claude /cc-sdd/design "Focus on authentication architecture"
claude /cc-sdd/task "Break down frontend components"
claude /cc-sdd/start-task "Create implementation todo list"
```

### 3. Interactive Specification Development

```bash
# Complete workflow - generates all specifications with user approval
claude /cc-sdd/spec "E-commerce platform with user authentication"
# Each phase presents document for review: approve or refine with feedback

# Refine individual phases
claude /cc-sdd/requirements "Add payment processing requirements"
claude /cc-sdd/design "Update architecture for microservices"
claude /cc-sdd/task "Focus on user authentication tasks"

# Re-run complete workflow for new features
claude /cc-sdd/spec "Add shopping cart and checkout functionality"
```

## Development Workflow

### 🚀 The Agent-Powered Cycle

```bash
# Complete specification generation with interactive approval
claude /cc-sdd/spec "Project description"  # Full Requirements → Design → Tasks workflow

# Phase-specific refinements
claude /cc-sdd/requirements "Additional requirements"  # EARS-format requirement generation
claude /cc-sdd/design "Architecture focus area"        # Technical design refinement
claude /cc-sdd/task "Component focus"                  # Task breakdown updates
claude /cc-sdd/start-task "Implementation planning"    # Integrated todo list creation

# Interactive development
# Each command presents document for review and approval
# Type "save" to approve or "refine [feedback]" to improve
# Use generated TASK.md to guide implementation
```

### 📊 Agent Workflow Architecture

```
                    ┌─────────────────┐
                    │  /cc-sdd/spec   │
                    │  Orchestrator   │
                    └─────────┬───────┘
                              │
                    ┌─────────▼────────┐
                    │  Initialize      │
                    │   CLAUDE.md      │
                    └─────────┬────────┘
                              │
    ┌─────────────────────────▼─────────────────────────┐
    │              Agent Coordination                   │
    │                                                   │
    │  Requirements ──► Design ──► Task Planning       │
    │    Specialist      Architect    Specialist        │
    │        │              │             │            │
    │        ▼              ▼             ▼            │
    │  REQUIREMENTS.md  DESIGN.md    TASK.md           │
    │   (EARS Format)   (Technical)  (Actionable)      │
    │                                                   │
    └───────────────────┬───────────────────────────────┘
                        │
              ┌─────────▼─────────┐
              │  Update State &   │
              │ WORKFLOW_CONTEXT  │
              └─────────┬─────────┘
                        │
    ┌───────────────────▼─────────────────────┐
    │           Individual Commands           │
    │                                         │
    │  /cc-sdd/requirements ──► Refine reqs   │
    │  /cc-sdd/design ──────► Update arch     │
    │  /cc-sdd/task ────────► Modify tasks    │
    │                                         │
    │  Each command uses specialized agents   │
    │  with interactive approval process      │
    └─────────────────────────────────────────┘
```

### ⚡ What Happens During Agent Coordination

1. **Requirements Phase** - Requirements Specialist generates EARS-format specs:
   - Analyzes project description
   - Creates Ubiquitous, Event-Driven, State-Driven patterns
   - Ensures testability and atomic requirements
   - Outputs comprehensive REQUIREMENTS.md

2. **Design Phase** - Design Architect creates technical specifications:
   - Reads requirements and analyzes architectural drivers
   - Defines system components and interfaces
   - Selects technology stack and patterns
   - Outputs detailed DESIGN.md with implementation guidelines

3. **Task Planning** - Task Planner breaks down into actionable work:
   - Maps requirements to implementation tasks
   - Assigns complexity estimates and dependencies
   - Creates phased implementation roadmap
   - Outputs structured TASK.md with full traceability

### 🔍 Specification Consistency

Agent coordination ensures specification integrity:

**Cross-Phase Validation:**
- Design Architect validates against all requirements
- Task Planner ensures complete requirement coverage
- Each agent reads and builds upon previous phase outputs
- .claude/WORKFLOW_CONTEXT.md maintains session continuity

**EARS Format Compliance:**
- Requirements Specialist enforces EARS patterns
- Atomic, testable requirement generation
- Clear acceptance criteria and system boundaries
- Comprehensive error handling specifications

## Project Structure

```
project/
├── .claude/                        # Claude Code configuration
│   ├── PROJECT_STATE.md            # Workflow status tracking
│   ├── WORKFLOW_CONTEXT.md         # Agent coordination context
│   ├── agents/                     # Specialized AI agents
│   │   ├── requirements-specialist.md  # EARS format expert
│   │   ├── design-architect.md         # Technical architecture
│   │   └── task-planner.md             # Development task breakdown
│   ├── commands/cc-sdd/            # Namespaced slash commands
│   │   ├── spec.md                 # Master orchestrator
│   │   ├── requirements.md         # Requirements generation
│   │   ├── design.md               # Design creation
│   │   ├── task.md                 # Task planning
│   │   └── start-task.md           # Todo integration
│   └── settings.local.json         # Agent permissions configuration
├── specs/                          # Generated specifications
│   ├── REQUIREMENTS.md             # EARS-format requirements
│   ├── DESIGN.md                   # Technical architecture
│   └── TASK.md                     # Structured task breakdown
└── [your implementation files]
```

## Advanced Features

### 📋 Specification Templates

#### EARS Format Requirements (Generated by Requirements Specialist)
```markdown
#### REQ-001 (Event-Driven)
When a user submits valid login credentials, the system shall authenticate and return a JWT token

#### REQ-002 (State-Driven)
While a user session is active, the system shall authorize API requests based on token validation

#### REQ-003 (Unwanted Behavior)
If login credentials are invalid, then the system shall return a 401 error with rate limiting applied

#### REQ-004 (Optional)
Where two-factor authentication is enabled, the system shall require secondary verification before token generation
```

#### Task with Traceability (Generated by Task Planner)
```markdown
- [ ] [TASK-010] Implement JWT Authentication Service
  - **Complexity**: M
  - **Priority**: P0
  - **Dependencies**: TASK-001 (Database setup)
  - **Requirements**: REQ-001, REQ-002, REQ-003
  - **Files**: src/services/auth.service.js, src/middleware/jwt.middleware.js
  - **Details**: Create JWT token generation and validation service
```


## Team Collaboration

### 🤝 Agent-Powered Collaboration

- **Intelligent Automation** - AI agents handle specification generation
- **No Background Processes** - All agent actions are explicit and traceable
- **Individual Choice** - Each developer can use agents or access specifications directly
- **Shared Intelligence** - AI-generated specifications benefit the entire team
- **Context Preservation** - .claude/WORKFLOW_CONTEXT.md maintains session continuity

### 👥 Best Practices

#### **For New Projects**
1. **AI-Assisted Specification** - Use `/spec` for complete requirements, design, and task generation
2. **Collaborative Refinement** - Team reviews and refines AI-generated specifications
3. **Phase-Specific Updates** - Use `/requirements`, `/design`, `/task` for targeted improvements
4. **Living Documentation** - Re-run agents as project evolves

#### **For Existing Projects**
1. **Documentation Generation** - Use `/spec` to create specifications for existing features
2. **Architecture Analysis** - Design Architect agent analyzes current codebase structure
3. **Gap Identification** - Task Planner identifies documentation and improvement opportunities
4. **Incremental Enhancement** - Use individual phase commands for specific improvements
5. **Knowledge Capture** - AI agents help document tribal knowledge systematically

## Installation Options

### 🚀 Quick Install
```bash
curl -sSL https://raw.githubusercontent.com/pdoronila/cc-sdd/main/quick-install.sh | bash
```

### 🔧 Local Development Install
```bash
# From cloned repository directory
git clone https://github.com/pdoronila/cc-sdd.git
cd /path/to/your/project/
../cc-sdd/install-local-copy.sh
```

### 📋 Manual Install
```bash
git clone https://github.com/pdoronila/cc-sdd.git
cp -r cc-sdd/.claude /path/to/your/project/
cp -r cc-sdd/specs /path/to/your/project/
```

### ✅ Verify Installation
```bash
claude /spec "Test project"   # Test command availability
```

## Benefits

### For Developers
- **AI-Generated Clarity** - Precise EARS-format requirements eliminate ambiguity
- **Intelligent Task Breakdown** - Task Planner creates optimal implementation sequences
- **Architecture Guidance** - Design Architect provides technical implementation roadmaps
- **No Workflow Disruption** - Agent-based approach integrates seamlessly
- **Context Preservation** - Workflow context maintained across development sessions

### For Teams
- **Universal Adoption** - AI agents work with any project type or technology stack
- **Shared Intelligence** - AI-generated specifications provide consistent quality
- **Requirement Precision** - EARS format eliminates interpretation ambiguity
- **Full Traceability** - Requirements flow through design to implementation tasks
- **Systematic Approach** - Agent coordination ensures comprehensive coverage
- **Scalable Adoption** - Use individual agents or complete orchestrated workflow

### For Projects
- **AI-Enhanced Planning** - Intelligent task breakdown with dependency analysis
- **Living Specifications** - Agent-generated docs evolve with project needs
- **Consistent Quality** - EARS format ensures testable, atomic requirements
- **Rapid Knowledge Transfer** - AI-generated architecture documentation accelerates onboarding
- **Systematic Evolution** - Agent coordination manages specification complexity
- **Intelligent Prioritization** - Task Planner optimizes development sequences

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

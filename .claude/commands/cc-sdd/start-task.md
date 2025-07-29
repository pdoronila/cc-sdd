---
allowed-tools: Read, Grep, Glob, Write, Bash(git:*), mcp__*
description: Integrate task, requirements and design for comprehensive planning
argument-hint: "optional task focus or refinement instructions"
---

# Start Task Command

Orchestrate a comprehensive planning session by integrating task breakdown, requirements, and technical design documents into an actionable todo list.

## Context
- Task focus: $ARGUMENTS
- Current task file: @specs/TASK.md (if exists)
- Requirements file: @specs/REQUIREMENTS.md (if exists) 
- Design file: @specs/DESIGN.md (if exists)
- Git status: !`git status --short`

## Task
Create an integrated planning session that considers all three project perspectives:

### Phase 1: Document Discovery & Analysis
1. Check for existence of TASK.md, REQUIREMENTS.md, and DESIGN.md
2. If missing critical files, prompt user to run appropriate commands first:
   - Missing REQUIREMENTS.md → suggest `/cc-sdd/requirements [feature description]`
   - Missing DESIGN.md → suggest `/cc-sdd/design [design focus]`
3. Read and analyze all available specification documents
4. Extract key tasks from TASK.md

### Phase 2: Integration & Planning
1. **Requirements Coverage**: Map tasks to requirements for traceability
2. **Design Alignment**: Verify tasks align with technical design approach
3. **Gap Analysis**: Identify missing implementation steps or conflicts
4. **Dependency Resolution**: Determine task ordering and prerequisites

### Phase 3: Todo List Creation
1. Use TodoWrite tool to create comprehensive internal todo list from TASK.md
2. Organize tasks by priority based on:
   - Requirements criticality 
   - Technical dependencies from design
   - Implementation complexity
3. Break down complex tasks into smaller actionable items
4. Add any missing implementation steps discovered during integration

### Phase 4: Plan Presentation
1. Present integrated todo list showing:
   - Task breakdown with requirement/design context
   - Priority ordering and dependencies
   - Clear next steps for implementation
2. **User Review Required**: Present plan and wait for user approval
3. Keep todo list active for tracking progress throughout implementation

## Quality Gates
- All critical requirements have corresponding tasks
- Tasks follow technical design constraints
- Todo list is actionable with clear priorities
- Dependencies are properly sequenced
- Application compiles with no errors after implementation
- Tests are written to verify all implemented features
- All tests pass without errors
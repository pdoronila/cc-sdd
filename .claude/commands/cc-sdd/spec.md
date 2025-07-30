---
allowed-tools: Read, Write, Bash(*), mcp__*
description: Orchestrate complete spec-driven development workflow
argument-hint: "project description"
---

# Spec-Driven Development Orchestrator

You are the master orchestrator for spec-driven development. Execute the complete workflow by sequentially initiating specialized sub-agents.

**WORKFLOW EXECUTION**: Execute the complete workflow by running each agent in sequence. Agents will directly create their respective files.

## Context
- Project description: $ARGUMENTS
- Current directory: !`pwd`
- Existing files: !`ls -la`

## Workflow Execution

1. **Requirements Phase**
   - Create initial project context in `CLAUDE.md`
   - Use requirements sub-agent to generate and write `specs/REQUIREMENTS.md`
   - Agent writes file directly, no user interaction required

2. **Design Phase**
   - Ensure requirements exist and are complete
   - Use design sub-agent to generate and write `specs/DESIGN.md`
   - Agent writes file directly, no user interaction required

3. **Task Planning Phase**
   - Verify requirements and design documents exist
   - Use task sub-agent to generate and write `specs/TASK.md`
   - Agent writes file directly, no user interaction required

4. **State Persistence**
   - Update `.claude/PROJECT_STATE.md` with current workflow status

## Execution Steps

1. Initialize project structure:
   ```bash
   mkdir -p specs
   # Add project context to CLAUDE.md (append if exists, create if not)
   if [ ! -f "CLAUDE.md" ]; then
     touch CLAUDE.md
   fi
   
   # Check if project context already exists to avoid duplicates
   if ! grep -q "Generated using cc-sdd workflow" CLAUDE.md; then
     echo "" >> CLAUDE.md
     echo "-----" >> CLAUDE.md
     echo "# Spec-Driven Development Project" >> CLAUDE.md
     echo "Project: $ARGUMENTS" >> CLAUDE.md
     echo "Created: $(date)" >> CLAUDE.md
     echo "Generated using cc-sdd workflow" >> CLAUDE.md
     echo "-----" >> CLAUDE.md
   fi
   ```

2. Execute requirements phase:
   - Use the requirements sub-agent to generate and write `specs/REQUIREMENTS.md`
   - Agent handles all file operations directly

3. Execute design phase:
   - Use the design sub-agent to generate and write `specs/DESIGN.md`
   - Agent handles all file operations directly

4. Execute task planning:
   - Use the task sub-agent to generate and write `specs/TASK.md`
   - Agent handles all file operations directly

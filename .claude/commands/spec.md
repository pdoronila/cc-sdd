---
allowed-tools: Read, Write, Bash(*), mcp__*
description: Orchestrate complete spec-driven development workflow
argument-hint: "project description"
---

# Spec-Driven Development Orchestrator

You are the master orchestrator for spec-driven development. Execute the complete workflow by sequentially initiating specialized sub-agents.

## Context
- Project description: $ARGUMENTS
- Current directory: !`pwd`
- Existing files: !`ls -la`

## Workflow Execution

1. **Requirements Phase**
   - Create initial project context in `PROJECT_CONTEXT.md`
   - Delegate to requirements sub-agent for EARS format requirements
   - Output: `REQUIREMENTS.md`

2. **Design Phase**
   - Ensure requirements exist and are complete
   - Delegate to design sub-agent for technical architecture
   - Output: `DESIGN.md`

3. **Task Planning Phase**
   - Verify requirements and design documents exist
   - Delegate to task sub-agent for task breakdown
   - Output: `TASK.md` with structured tasks

4. **State Persistence**
   - Update `.claude/PROJECT_STATE.md` with current workflow status
   - Commit all generated documents to Git

## Execution Steps

1. Initialize project structure:
   ```bash
   mkdir -p specs
   echo "# Project: $ARGUMENTS" > .claude/PROJECT_CONTEXT.md
   echo "Created: $(date)" >> .claude/PROJECT_CONTEXT.md
   ```

2. Execute requirements phase:
   - Use the requirements sub-agent to generate EARS-format requirements
   - Save output to `specs/REQUIREMENTS.md`

3. Execute design phase:
   - Use the design sub-agent to create technical design
   - Save output to `specs/DESIGN.md`

4. Execute task planning:
   - Use the task sub-agent to create actionable tasks
   - Save output to `specs/TASK.md`

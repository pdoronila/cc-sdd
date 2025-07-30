---
allowed-tools: Read, Write, Bash(git:*), mcp__*
description: Create or update task breakdown from requirements and design
argument-hint: "task focus or specific component"
---

# Task Command

Generate or update task breakdown based on requirements and technical design.

## Context
- Task focus: $ARGUMENTS
- Requirements: @specs/REQUIREMENTS.md
- Design: @specs/DESIGN.md
- Current tasks: @specs/TASK.md (if exists)
- Git status: !`git status --short`

## Task
Delegate to the task planner sub-agent to create actionable development tasks and write the file directly.

The sub-agent should:
1. Analyze requirements and design documents
2. Break down into implementable tasks
3. Estimate complexity and dependencies
4. Write the complete document to `specs/TASK.md`
5. Mark completed tasks when updating

After task generation and writing:
- Validate design coverage
- Check dependency graph
- Ensure no orphaned tasks
- Generate final quality report

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
- Git status: Attempt to get git status (continue if fails)

## Task
Create a focused planning session for the first non-completed task, integrating requirements and design context:

### Phase 1: Document Discovery & Git Status
1. Attempt to get git status using bash (if git status fails, continue anyway)
2. Check for existence of TASK.md, REQUIREMENTS.md, and DESIGN.md
3. If missing critical files, prompt user to run appropriate commands first:
   - Missing REQUIREMENTS.md → suggest `/cc-sdd/requirements [feature description]`
   - Missing DESIGN.md → suggest `/cc-sdd/design [design focus]`
   - Missing TASK.md → suggest `/cc-sdd/task [task description]`
4. Read and analyze all available specification documents
5. **Focus**: Identify the first non-completed task from TASK.md (if no tasks exist, inform user)

### Phase 2: Task-Focused Integration
1. **Single Task Focus**: Work only with the first non-completed task found
2. **Requirements Coverage**: Map this specific task to relevant requirements
3. **Design Alignment**: Verify this task aligns with technical design approach
4. **Task Breakdown**: Identify sub-steps needed for this specific task

### Phase 3: Focused Todo List Creation
1. Use TodoWrite tool to create todo list for ONLY the first non-completed task
2. Break down this single task into smaller actionable items based on:
   - Requirements context
   - Technical design constraints
   - Implementation complexity
3. Do NOT create todos for the entire project - focus only on the current task
4. Add any missing implementation steps discovered for this specific task

### Phase 4: Focused Plan Presentation
1. Present focused todo list for the single task showing:
   - Task breakdown with requirement/design context
   - Clear sub-steps for this specific task
   - Implementation approach based on design constraints
2. **User Review Required**: Present task-focused plan and wait for user approval
3. Keep todo list active for tracking progress on this specific task

### Phase 5: Task Completion Tracking
**IMPORTANT**: After the task implementation is complete (when all todo items are marked as completed):
1. **Auto-mark Task Complete**: When all todo items for the current task are completed, automatically mark the corresponding task as complete in specs/TASK.md
2. **Update Task Status**: Change the markdown checkbox from `- [ ]` to `- [x]` for the completed task
3. **Task Completion Logic**: 
   - Monitor todo list completion status
   - When all todos for the focused task are marked completed, update TASK.md
   - Find the specific task line in TASK.md and mark it as completed
   - Preserve all task metadata (complexity, priority, dependencies, etc.)
4. **Confirmation**: Inform user that the task has been marked as complete in specs/TASK.md

## Quality Gates
- Single task focus is maintained throughout planning
- Git status failures do not interrupt the planning process
- Current task aligns with requirements and design constraints
- Todo list is actionable with clear sub-steps for the focused task
- Task dependencies are identified and addressed
- Implementation approach is clear and feasible
- Plan provides sufficient detail to begin implementation
- Task completion is automatically tracked in specs/TASK.md when all todos are completed
- Task status updates preserve all metadata and formatting in TASK.md
---
allowed-tools: Read, Write, Bash(ls:*), Bash(tree:*), mcp__*
description: Create technical design from requirements
argument-hint: "design focus area or refinement instructions"
---

# Design Command

Generate or refine technical design based on requirements.

## Context
- Design focus: $ARGUMENTS
- Requirements: @docs/specs/REQUIREMENTS.md
- Existing design: @docs/specs/DESIGN.md (if exists)
- Project structure: !`tree -L 2 -I 'node_modules|.git'`

## Task
Delegate to the design architect sub-agent to create comprehensive technical design documentation.

The sub-agent should:
1. Read and analyze all requirements
2. Create architecture decisions
3. Define component structure
4. Specify interfaces and data flow
5. Document technology choices

After creating design:
- Validate all requirements are covered
- Generate traceability matrix
- Check for design completeness
- Only proceed if quality gate passes

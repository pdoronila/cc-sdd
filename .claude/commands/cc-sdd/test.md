---
allowed-tools: Read, Write, Bash(test:*), mcp__*
description: Create or update test plan from requirements and design
argument-hint: "test focus or specific testing area"
---

# Test Command

Generate or update comprehensive test plan based on requirements and technical design.

## Context
- Test focus: $ARGUMENTS
- Requirements: @specs/REQUIREMENTS.md
- Design: @specs/DESIGN.md
- Current tests: @specs/TEST.md (if exists)
- Git status: !`git status --short`

## Task
Delegate to the qa-tester sub-agent to create comprehensive test plan with full requirement traceability and write the file directly.

The sub-agent should:
1. Analyze requirements and design documents
2. Create test scenarios with full traceability to requirements
3. Define unit, integration, and acceptance tests
4. Map every requirement to specific test cases
5. Write the complete document to `specs/TEST.md`
6. Include test data requirements and coverage targets

After test plan generation and writing:
- Validate requirement coverage completeness
- Check test traceability matrix
- Ensure comprehensive test strategy
- Generate final coverage report
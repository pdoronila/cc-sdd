---
allowed-tools: Read, Write, WebSearch, mcp__*
description: Generate or refine requirements using EARS format
argument-hint: "feature description or refinement instructions"
---

# Requirements Command

Generate or refine software requirements using the EARS (Easy Approach to Requirements Syntax) format.

## Context
- Feature/Project: $ARGUMENTS
- Existing requirements: @specs/REQUIREMENTS.md (if exists)
- Project context: @CLAUDE.md

## Task
Delegate to the requirements specialist sub-agent to create or refine requirements in EARS format.

The sub-agent should:
1. Analyze the feature description
2. Generate comprehensive EARS-format requirements
3. Organize by requirement type (Ubiquitous, Event-Driven, State-Driven, Optional, Unwanted Behavior)
4. Ensure testability and clarity

After generating requirements, run quality validation:
- Check for unique IDs and EARS compliance
- Generate quality gate report
- Only proceed if validation passes

# Complete Task and Continue

You are a specialized AI assistant for completing the current task and seamlessly transitioning to the next task in spec-driven development workflows. This command handles task completion and automatically starts the next task.

## Your Role
You are an expert in:
- Task completion verification and documentation
- Automated progress tracking and updates
- Seamless workflow transitions
- Context management between tasks
- Continuous development momentum

## Automated Completion and Transition

**Note**: This command automatically handles the complete task lifecycle without any hooks. It reads task states from specs/tasks.md, runs quality validation inline, and manages task transitions through emoji symbol updates.

### 1. Current Task Completion
Help complete the current task by:
- Gathering completion information from the user
- Verifying all acceptance criteria are met
- Updating task status in specifications
- Recording completion metrics and notes

### 2. Progress Update
Automatically update project progress:
- Mark task as completed in `specs/tasks.md`
- Update completion timestamps and effort
- Identify newly unblocked dependent tasks
- Recalculate progress metrics

### 3. Next Task Selection
Seamlessly transition to next task by:
- Analyzing updated dependencies
- Selecting optimal next task
- Loading fresh context for new task
- Providing immediate implementation guidance

## Completion and Transition Workflow

### Task Completion Summary
Please provide details about the task you just completed:

**What task did you finish?**
[User provides task ID or description]

**Implementation Summary:**
- **What was built**: [Description of functionality]
- **Files modified**: [List of files created/changed]
- **Testing completed**: [Test coverage and validation]
- **Integration status**: [How it connects with existing code]
- **Any deviations**: [Changes from original plan]

### Automatic Processing

#### Automatic Task State Detection and Processing

When you run `/spec-done`, it automatically detects your current task state from specs/tasks.md and handles the complete workflow:

**Detection Process:**
1. ✅ **Find Current Task**: Scans specs/tasks.md for 🔄 (started) tasks
2. ✅ **Run Quality Validation**: Inline validation of compile, test, lint, format
3. ✅ **Handle Results**: Updates task symbols based on validation outcome

**Quality Validation Flow:**
- **Project Detection**: Automatically detects project type (package.json, requirements.txt, etc.)
- **Compile Check**: Runs build/compile commands for the detected project type
- **Test Validation**: Executes test suite to ensure no regressions
- **Code Quality**: Runs linting and formatting checks with auto-fixes
- **Type Checking**: Validates types (if applicable for the language)

**Task State Updates:**
- **Quality Pass**: 🔄 (started) → 🎉 (done) + auto-start next task
- **Quality Fail**: Keep as 🔄 (started) + show issues to fix

*Note: All validation runs inline within the command - no external hooks or scripts!*

#### Completion Verification
- ✅ **Task Identification**: [Confirm task from specs/tasks.md]
- ✅ **Acceptance Criteria**: [Verify requirements met]
- ✅ **Implementation Ready**: [Code complete and tested]

#### Progress Update
- ✅ **Status Update**: ⏳ → ✅ in specs/tasks.md
- ✅ **Metrics**: Update completion percentage and velocity
- ✅ **Dependencies**: Unblock dependent tasks
- ✅ **Documentation**: Record completion details

#### Next Task Selection
- ✅ **Dependency Analysis**: Check what's now available
- ✅ **Priority Evaluation**: Select optimal next task
- ✅ **Context Loading**: Gather relevant specifications
- ✅ **Implementation Ready**: Prepare immediate guidance

### Seamless Transition to Next Task

**Why This Next Task**:
- ✅ All prerequisites now completed
- 🎯 High impact on project progress
- ⏱️ Logical continuation of current work
- 🔗 Builds on what was just completed

### Implementation Context for Next Task

**Specifications Context**:

From `specs/requirements.md`:
[Relevant requirements for next task]

From `specs/design.md`:
[Relevant design decisions for next task]

From `specs/api-spec.md` (if applicable):
[Relevant API specifications for next task]

**Implementation Plan**:
1. **Setup**: [Specific setup steps]
2. **Core Work**: [Main implementation tasks]
3. **Integration**: [How to connect with existing code]
4. **Testing**: [Verification requirements]

### Ready to Continue Implementation

**Current Focus**: [Next Task Title]
**Fresh Context**: Loaded from specifications
**Build On**: [How this connects to completed work]

Let's continue the momentum and implement this next task. I'll guide you through each step.

**When you complete this next task, simply run `/spec-done` again to continue the flow.**

## Streamlined Development Flow

### The Complete Cycle
```
1. claude /spec-work    # Finds next task, sets 🔄 (started), provides guidance
2. Implement the task   # Code, test, verify locally
3. claude /spec-done    # Inline quality validation + 🔄 → 🎉 + starts next
4. Repeat...
```

### Benefits of This Hook-Free Approach
- **Zero Dependencies**: No hooks, no background processes, no interference
- **Fully Automated Quality**: Inline validation with detailed feedback
- **Two-Command Workflow**: Just `/spec-work` and `/spec-done`
- **Self-Contained**: All logic embedded in slash commands
- **Team-Friendly**: Won't affect other developers' workflows
- **Portable**: Works in any environment without setup
- **Transparent**: All actions visible and controllable

## Command Execution Steps

When this command runs, it should:

1. **Read specs/tasks.md** to find current 🔄 (started) task
2. **Detect project type** by checking for package.json, requirements.txt, Cargo.toml, etc.
3. **Run quality validation** inline:
   - Execute compile/build commands
   - Run test suite 
   - Check linting with auto-fixes
   - Validate formatting and types
4. **Update task state** based on results:
   - Quality pass: 🔄 → 🎉 (done) in specs/tasks.md
   - Quality fail: Keep 🔄, show issues to fix
5. **Auto-start next task** if quality passed (like running /spec-work)

Begin by finding the current started task, running comprehensive quality validation, and managing the task transition based on results.
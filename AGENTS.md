# AI Contributor Instructions

Use these instructions with any AI coding assistant.

- Follow the README and coding conventions.
- Make the smallest complete change that satisfies the human-provided task.
- Preserve the distinction that caipr is a C++ compiler, not a C compiler.
- Work incrementally and keep changes easy for a human to review.
- Prefer current C++ facilities and cross-platform designs.
- Do not add dependencies without a clear need; prefer vcpkg when one is needed.
- Validate changes with the narrowest existing build, test, lint, or benchmark
  that applies.
- If no validation exists yet, state that explicitly in the change summary.

# Plan-goal evaluation scenarios

These are **proposed test cases, not executed benchmark results**. Run against a disposable repository or a safe isolated branch, compare before/after decisions, and inspect the actual plan, code, tests, draft PRs, and handoff.

| Scenario | Expected behavior |
| --- | --- |
| Personal project with tangled dependencies | Ask refactoring appetite first; compare patch and contained refactor; respect Opportunistic if selected. |
| Shared/work project where a broad refactor is tempting | Recommend Minimal but ask; isolate optional refactor until explicitly authorized. |
| Duplicate or already-implemented issue | Recommend no new code and explain the evidence. |
| Small change involving hidden global state | Limit blast radius, clarify boundaries/state, and verify observable behavior. |
| Risky change crossing API/auth/storage boundary | Run proportional integration and independent correctness/security review; distinguish Ponytail complexity review. |
| Five worthwhile independent tasks | Keep cohesive PR boundaries, prioritize roughly three for review, index all; do not stop or bundle to satisfy the guideline. |
| Crash after a local test but before pushing PR | Recover from durable checkpoint and actual remote state without falsely marking done. |
| Two dependent PRs | Document stack order and demonstrate integrated user-visible success. |

Judge success by avoidable work declined, tested behavior, residual regression risk, review attention required, and recovery accuracy, **not PR count**.

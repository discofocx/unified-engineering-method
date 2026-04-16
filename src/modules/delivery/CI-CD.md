# CI and CD

Continuous integration, continuous delivery, and rollback.

---

## CI Is About Trust

CI answers: **"Is this change good enough to integrate?"**

| Step               | Purpose           |
| ------------------ | ----------------- |
| Format / lint      | Code quality      |
| Unit tests         | Correctness       |
| Integration tests  | System behavior   |
| Static analysis    | Safety            |
| Build / package    | Artifact creation |
| Generate artifacts | Deliverables      |
| Preview builds     | Early feedback    |

---

## CD Is About Movement

CD answers: **"Can we safely move this artifact through environments and channels?"**

| Step                  | Purpose               |
| --------------------- | --------------------- |
| Deploy to environment | Runtime placement     |
| Smoke tests           | Basic validation      |
| Gate promotion        | Confidence checkpoint |
| Rollback support      | Safety net            |
| Publish release notes | Communication         |
| Publish binaries      | Distribution          |

---

## Deployment Authorization

Who can promote an artifact — and to where — depends on the tier.

| Tier                   | Dev / Staging                       | Production / Stable                                     |
| ---------------------- | ----------------------------------- | ------------------------------------------------------- |
| **Solo / Personal**    | Developer or agent deploys directly | Developer promotes when ready                           |
| **Solo / Consultancy** | Agent can deploy to dev/staging     | Human approval required before production promotion     |
| **Small Team**         | Automated deployment to dev         | Human-in-the-loop required for any production promotion |

The principle: **automation increases toward dev; human oversight increases toward production.**

Promotion to production is a quality gate, not a mechanical step. It depends on human judgment — QA validation, client readiness, risk assessment — that cannot be automated away. An agent completing the core loop may prepare and stage an artifact, but a human pulls the trigger on production.

This applies regardless of how the promotion is implemented — scripted, CI-triggered, or manual. The ceremony is the human decision, not the mechanism.

---

## CI on Merge to Main

- Build artifact
- Assign build metadata
- Publish internal artifact
- Deploy automatically to dev
- Run smoke tests

---

## Rollback

- Rollback by redeploying the prior artifact or tag
- Never patch production manually
- Never rebuild old source for rollback if the old artifact exists

Rollback is a deployment operation, not a source control operation.

---

## Observability

Delivery is not done when the artifact is deployed. It is done when you can confirm the change achieved its intent.

The issue said "improve search performance." Did it? Without a way to measure, deployment is a leap of faith. The feedback loop is: **deploy → observe → confirm intent.**

For Class 2+ projects, a deployment should be paired with a way to verify the change worked:

- Metrics dashboards (latency, error rates, throughput)
- Structured logs that surface errors without manual log-file archaeology
- Smoke tests or health checks that run post-deployment
- Crash reporting for client-facing applications
- Client or user feedback channels

This links Delivery back to [Knowledge](../knowledge/) — the issue stated the intent, the deployment confirms or denies it — and back to [Change Management](../change-management/) — the issue is not truly done until the change is verified in the delivery environment.

The framework prescribes the principle, not the tooling. What matters is that the question "did this change work?" has an answer beyond "CI passed and we deployed it."

Observability is usually an afterthought — treated as something for large teams with dedicated infrastructure. But the cost of not having it shows up as debugging sessions where you are asking users to send screenshots of error messages or manually inspecting log files. Wiring basic observability early — even just structured logging and crash reporting — pays off the moment someone other than you uses the software.

For construction-side observability — enforcing logging conventions during development through linter rules — see [Toolchain — Conditional Categories](../construction/TOOLCHAIN.md#conditional-categories). Construction ensures the code **produces** structured telemetry. Delivery ensures someone **consumes** it.

---

## Infrastructure as Code

Infrastructure changes — database migrations, server configurations, IaC templates, deployment scripts — are code. They follow the same Change Management path as application code: issue → branch → validation → PR → merge.

Infrastructure linters (`tflint`, schema validators, migration checkers) are part of the [validation surface](../construction/VALIDATION.md). The distinction is that application code changes what the software does; infrastructure code changes where and how it runs. Both are tracked, validated, and promoted.

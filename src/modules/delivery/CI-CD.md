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

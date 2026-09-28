# Open Cube roadmap

The documents in `product/`, `architecture/`, `architecture/ADR/` and `specs/` are the source of truth for the product direction. GitHub issues are the executable backlog.

## Phase 1 — Workbench shell

- [#4 Core domain model](https://github.com/rajanbor/open-cube/issues/4)
- [#5 IDE-style shell](https://github.com/rajanbor/open-cube/issues/5)
- [#6 Dockable layout](https://github.com/rajanbor/open-cube/issues/6)
- [#7 Inspector and status bar](https://github.com/rajanbor/open-cube/issues/7)
- [#8 Activity views and workspace explorer](https://github.com/rajanbor/open-cube/issues/8)

Shipped in the desktop client and specified in `specs/`: the workbench shell
(`WORKBENCH_SHELL.md`), the in-app inspector (`INSPECTOR_MODEL.md`), the
terminal panel (`TERMINAL_PANEL.md`), the canvas workflow editor
(`CANVAS_WORKFLOW.md`), the model catalogue and model version control
(`MODEL_CATALOG.md`) and usage accounting (`USAGE_ACCOUNTING.md`). Their
execution halves — live ptys, running workflows, provider launches — belong to
Phase 2.

## Phase 2 — Runtime, sandbox and terminals

- [#9 workbenchd](https://github.com/rajanbor/open-cube/issues/9)
- [#10 Agent runtime](https://github.com/rajanbor/open-cube/issues/10)
- [#11 Provider connections](https://github.com/rajanbor/open-cube/issues/11)
- [#12 Native sandbox provider](https://github.com/rajanbor/open-cube/issues/12)
- [#13 Container sandbox provider](https://github.com/rajanbor/open-cube/issues/13)
- [#14 Terminal manager](https://github.com/rajanbor/open-cube/issues/14)
- [#15 Storage and event replay](https://github.com/rajanbor/open-cube/issues/15)

## Phase 3 — Machines and orchestration

- [#16 Local machine capability discovery](https://github.com/rajanbor/open-cube/issues/16)
- [#17 Remote machine pairing](https://github.com/rajanbor/open-cube/issues/17)
- [#18 Live Canvas](https://github.com/rajanbor/open-cube/issues/18)
- [#19 Agent delegation](https://github.com/rajanbor/open-cube/issues/19)

## Phase 4 — Optional cloud and releases

- [#20 Optional account, encrypted sync and mobile](https://github.com/rajanbor/open-cube/issues/20)
- [#21 Cross-platform distribution](https://github.com/rajanbor/open-cube/issues/21)

## Phase 5 — Teams

Two milestones, both governed by
[ADR 009: an optional control plane](../adr/009-optional-control-plane.md), and
both waiting on the workbench daemon (#9) and the agent runtime (#10): neither
is worth anything until an agent can actually run locally.

**[Enterprise: tenant and shared workbench](https://github.com/rajanbor/open-cube/milestone/1)**
— a company creates a tenant, its people sign in as themselves, and they share
one workbench definition while the work still runs on each person's machine.
Specified in [`ENTERPRISE_TENANCY.md`](../specs/ENTERPRISE_TENANCY.md).

- [#73 The control-plane boundary, in types and a test](https://github.com/rajanbor/open-cube/issues/73)
- [#74 Create a tenant, verify a domain, invite people, hold roles](https://github.com/rajanbor/open-cube/issues/74)
- [#75 Each person signs in as themselves](https://github.com/rajanbor/open-cube/issues/75)
- [#76 Publish shared definitions and policy bundles](https://github.com/rajanbor/open-cube/issues/76)
- [#77 Usage and audit with a name on them](https://github.com/rajanbor/open-cube/issues/77)
- [#78 The Enterprise panel in Settings](https://github.com/rajanbor/open-cube/issues/78)

**[@cube: call an agent from where the work is talked about](https://github.com/rajanbor/open-cube/milestone/2)**
— `@cube fix the failing checkout test` in a Slack thread runs an agent in the
bound workbench and answers in the thread, with the provenance the app always
shows. Specified in [`MENTION_INVOCATION.md`](../specs/MENTION_INVOCATION.md).

- [#79 The mention contract, independent of Slack](https://github.com/rajanbor/open-cube/issues/79)
- [#80 Slack — mention, thread session, reply](https://github.com/rajanbor/open-cube/issues/80)
- [#81 Bindings — which channel is which workbench](https://github.com/rajanbor/open-cube/issues/81)
- [#82 Approvals in the thread](https://github.com/rajanbor/open-cube/issues/82)
- [#83 Offline is an answer](https://github.com/rajanbor/open-cube/issues/83)
- [#84 A second surface, to prove the contract](https://github.com/rajanbor/open-cube/issues/84)

# ADR 009: an optional control plane

## Status

Proposed — the decision that governs the Enterprise tenancy and `@cube`
milestones. Nothing is implemented against it yet.

## Context

Two things the product is asked for cannot be done by a local application
alone.

A company wants a **tenant**: one workbench definition its people share, with
each employee signing in as themselves. A person wants to call an agent from
**where the work is talked about** — `@cube fix the failing checkout test` in
Slack — which means something must be listening when their laptop is asleep.

Both need a server. The product so far has none by design: no cloud backend, no
telemetry, no bundled credentials, and a security model whose whole argument is
that work happens on your machine, as a separate account, under policies you
can read. A server is exactly the thing that argument is built to avoid, so
introducing one is the kind of decision that is hard to walk back.

## Decision

There is one optional control plane, and the local workbench never requires it.

**Optional means optional.** Every surface works without a tenant: projects,
agents, sandboxes, terminals, usage, the inspector. A person who never signs in
loses the tenant and the mention relay, and nothing else. No feature that works
today may come to depend on it.

**The control plane holds definitions and accounting, never work.** What may
cross the boundary:

- who a member is, and what role they hold;
- workbench *definitions* — projects by name and remote, agent blueprints,
  policy bundles, sandbox shapes;
- accounting — tokens, cost and the kind of work, attributed to a member;
- mention envelopes — the text of a message addressed to the agent, the thread
  it came from, and the reply the agent chose to send.

What may never cross it:

- file contents, diffs, terminal output or any part of a workspace;
- provider credentials, API keys or tokens of any kind;
- prompts and answers of local sessions;
- anything a sandbox produced that the person did not choose to send.

**Execution stays on the person's machine.** The control plane may route a
request and record that it happened. It never runs an agent, never holds a pty,
and never reaches into a workspace. A mention that arrives while the machine is
offline waits, and the reply says so rather than pretending.

**Identity is per person, never per company.** A tenant does not act; its
members do. Every action carries the member who caused it, and a member's
permissions come from their role and the agent's blueprint — never from the
text of the message that triggered it.

**A message is data, not authority.** Text arriving from Slack, a code host or
anywhere else is untrusted input. It may ask for work inside what the agent is
already allowed to do. It may not widen a scope, name a different sandbox,
disable an approval or claim to speak for an administrator.

## Consequences

- The engine grows tenant and mention objects that are `None` on a machine that
  has never signed in, and every view states that plainly rather than hiding
  the feature.
- A test asserts the boundary list above: the payloads the control plane
  accepts have no field that could carry a workspace's contents.
- Two things become possible that were not: a company can hand its people one
  workbench, and an agent can be called from a thread. Both are opt-in, and
  both fail closed.
- The product acquires an operational surface it did not have — a service to
  run, secure and keep available. `.ai/specs/ENTERPRISE_TENANCY.md` and
  `.ai/specs/MENTION_INVOCATION.md` carry the detail; neither ships before the
  workbench daemon (#9) owns execution locally.

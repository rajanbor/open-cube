# Spec: enterprise tenancy

Governed by `.ai/adr/009-optional-control-plane.md`. Not implemented; this is
what "the company has its own workbench" means before anyone writes it.

## User outcome

A company creates a tenant. Its people sign in with their own accounts and open
the same workbench: the same projects, the same agents with the same
instructions and permissions, the same sandbox shapes, the same cost accounting
— while the work itself still runs on each person's machine, under their own
sandbox account.

One person changing an agent changes it for the team. One person's spend is
visible as theirs. Nobody shares a login.

## Scope

- **Tenant**: created by a person, identified by a name and a verified domain.
- **Membership**: invitation by email or domain join, with a role.
- **Individual accounts**: each member signs in as themselves, through the
  company's identity provider where there is one (OIDC), otherwise by email.
- **Shared definitions**: projects (by name and remote), agent blueprints,
  policy bundles, sandbox shapes and the model catalogue a tenant standardises
  on. Definitions, never contents.
- **Attribution**: tokens, cost and the kind of work, recorded per member and
  rolled up per tenant, using the accounting `USAGE_ACCOUNTING.md` already
  defines.
- **Audit**: who changed which definition, who invited whom, who ran what kind
  of work and when — not what the work said.
- **Seats**: how many members a tenant may have, and what that costs.

## Non-goals

- Running agents in the cloud. Execution stays on the member's machine.
- Holding provider credentials centrally. A member signs in to Claude or Codex
  on their own machine, as they do today.
- Syncing workspaces, diffs, prompts or terminal output. See ADR 009.
- Making the local workbench depend on any of this. A person who never signs in
  loses nothing they have today.

## Domain objects

| Object | What it holds |
| --- | --- |
| `Tenant` | id, name, verified domains, state, seat count, created |
| `Member` | id, tenant, display name, email, role, state, joined, last seen |
| `Role` | `owner`, `admin`, `member`, `viewer` — what each may change |
| `Invitation` | email or domain, role offered, who sent it, expiry, state |
| `SharedDefinition` | kind (project, agent blueprint, policy bundle, sandbox shape), payload, version, who last changed it |
| `PolicyBundle` | the permissions a tenant requires of every agent: what may never be granted, what always needs approval |
| `UsageAttribution` | member, period, tokens, cost, kind — the existing accounting with a name on it |
| `AuditEvent` | actor, action, subject, when. Definitions and membership only |

State transitions:

- Tenant: `created → verified → active → suspended`.
- Member: `invited → active → suspended → removed`. A removed member's machine
  keeps working; it stops receiving definitions and stops reporting usage.
- SharedDefinition: `draft → published → superseded`. A member's local copy is
  a draft until an admin publishes it; publishing is an audited act.

## UI and API behaviour

- **Settings → Enterprise**: signed out, it explains what a tenant is and
  offers to create or join one. Signed in, it shows the tenant, the member's
  role, the members list, published definitions, the audit trail and the seat
  count.
- **The account block** at the foot of the sidebar names the tenant under the
  person's name, or says `Local account` when there is none.
- **An agent** shows whether its blueprint is the tenant's published one, the
  member's local draft, or both differing — the same "draft differs" line the
  studio already uses, with a publisher and a date.
- **Usage** adds a per-member column beside per-model and per-agent, and the
  panel says which periods the tenant has data for.
- **A policy bundle that forbids something** shows as a blocked permission in
  the agent studio, naming the tenant as the source, exactly as a skill's
  missing permission does today.

## Permissions, privacy and failure modes

- A member's permissions come from their role and their agent's blueprint.
  Nothing a tenant sends may grant a local capability that the sandbox does not
  already allow: the control plane can narrow, never widen.
- Offline is normal. The workbench runs from its local copy; it queues nothing
  the person did not ask for, and the tenant view says when it last
  synchronised rather than implying it is live.
- A suspended tenant or revoked member stops synchronising. Local work
  continues; the app says which definitions are now unmanaged.
- The control plane never receives file contents, credentials, prompts or
  terminal output — asserted by a test over the payload types, not by a promise
  in a document.

## Acceptance criteria

- A tenant can be created, a domain verified, a member invited, a role changed
  and a member removed, each producing one audit event.
- A published agent blueprint arrives on a second machine and the studio shows
  its source, its version and its publisher.
- A policy bundle that forbids a permission blocks it in the studio with the
  tenant named as the reason.
- Usage reports a member column whose parts sum to the tenant total.
- Every surface behaves identically with no tenant, and the app says so once,
  where it matters, rather than hiding controls.
- A test enumerates the fields the control plane accepts and fails if a new one
  could carry workspace contents.

## Test plan

- Engine: membership and role transitions, definition publishing and
  supersession, attribution sums, the payload boundary test.
- Client: signed-out and signed-in Settings, an agent whose blueprint differs
  from the published one, a blocked permission attributed to a tenant.
- Offline: definitions read from the local copy, a stale-sync notice, no
  silent failure.

## Rollout

Behind the workbench daemon (#9), because a member's machine must be able to
run work locally before a tenant is worth anything. Opt-in from the first
release, and the local product keeps working untouched for people who never
create one.

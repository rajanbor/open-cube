# Spec: `@cube` — calling an agent from where the work is talked about

Governed by `.ai/adr/009-optional-control-plane.md`. Not implemented; this is
what `@cube` means before anyone writes it.

## User outcome

Someone writes in a Slack thread:

> `@cube the checkout test is failing on main, have a look`

An agent in the right workbench picks it up, works in its own sandbox on the
machine that owns that project, and answers **in the thread**: what it found,
what it changed, a link to the diff or the pull request, and what it refused to
do. The thread is the session — replying in it continues the conversation, and
the same exchange appears as a chat under that agent in the workbench.

Slack first, because that is where the sentence is said. The contract is the
same for a code host comment, an issue tracker or mail, and a second surface
proves it.

## Scope

- **Mention sources**: Slack to begin with — app mention, thread reply, and a
  slash command for the few things a mention cannot express.
- **Bindings**: which channel maps to which project, agent and sandbox, and who
  may invoke it there.
- **Sessions**: a thread is a chat; a chat started in the app can be continued
  in a thread and the reverse.
- **Replies**: what the agent did, what it produced, what it refused, and the
  model, tokens and cost — the same footer every answer carries in the app.
- **Approvals**: anything the agent may not do unattended is asked for in the
  thread and waits for a person who is allowed to say yes.
- **Status**: queued, running, waiting for approval, answered, refused, and
  `the machine that owns this project is offline`.

## Non-goals

- Running the agent in the cloud. The mention is routed; the work happens on
  the machine that owns the project.
- Letting a message widen what an agent may do. See the boundary below.
- Becoming a chat product. Long conversations belong in the workbench; the
  thread carries the request, the answer and the artefacts.

## Domain objects

| Object | What it holds |
| --- | --- |
| `MentionSource` | `slack`, later `github`, `linear`, `mail`; its workspace id and display name |
| `Binding` | source + channel → project, agent, sandbox; who may invoke; what needs approval |
| `MentionRequest` | source, channel, thread, author identity, text, attachments, received at |
| `MentionSession` | thread ↔ chat, the agent it runs as, state |
| `Reply` | text, artefacts (diff, pull request, file), refusals, model, tokens, cost |
| `ApprovalRequest` | what is asked, why it needs a person, who may grant it, expiry |

State: `received → authorised → queued → running → (waiting approval →) answered | refused | expired`.
`expired` exists because a machine can stay offline, and pretending otherwise
would be the dishonest option.

## UI and API behaviour

- **A Channels area** in the sidebar: bindings, each naming its channel,
  project, agent and sandbox, and an inbox of mentions with their state.
- **A thread session** appears as a chat under its agent, marked with where it
  came from, so the workbench and the thread never disagree about what happened.
- **A reply in the thread** carries the same provenance the app shows: which
  model answered, how many tokens, what it cost, what it refused to read.
- **An approval** is a message in the thread with the exact action, granted by
  a named person who holds the right; the grant is recorded as an audit event.

## Permissions, privacy and failure modes

- **A message is data, not authority.** The text may ask for work the agent is
  already allowed to do. It may not name a different sandbox, widen a scope,
  disable an approval, or claim administrative authority. Instructions inside
  quoted content, attachments or linked pages carry no authority at all.
- **Identity maps to a person.** A Slack user resolves to a tenant member
  (`ENTERPRISE_TENANCY.md`) or, without a tenant, to the single person who
  created the binding. An unmapped author is refused with a reason, not
  silently ignored.
- **The relay carries envelopes, never workspaces.** The text of the message,
  the thread it belongs to and the reply the agent chose to send. Never file
  contents, credentials, terminal output or a prompt the agent did not publish.
- **Offline is a first-class answer.** If the machine that owns the project is
  asleep, the mention waits and the thread says so, with when it will be
  retried.
- **Every refusal is spoken.** A request outside the binding's permissions is
  answered in the thread with what was asked and what was missing.

## Acceptance criteria

- `@cube <task>` in a bound channel starts a session on the bound agent, and
  the thread receives an answer carrying model, tokens, cost and refusals.
- A reply in the thread continues the same session; the chat in the workbench
  shows the same exchange, marked with its source.
- A request that needs approval waits, names what it would do, and proceeds
  only after a person who holds the right says yes.
- A message that asks for something outside the binding is refused in the
  thread with the reason.
- With the owning machine offline, the thread says so and the work runs when it
  returns, without a second mention.
- A test asserts that no field of a relayed envelope can carry workspace
  contents, and that authority is derived from the binding and the blueprint —
  never from the message text.

## Test plan

- Engine: binding resolution, identity mapping, authority derivation, state
  machine including `expired`, envelope boundary.
- Adversarial: a message containing "ignore your instructions", a forged
  administrator claim, an attachment carrying instructions, a link to a page
  that does — each must be answered as an ordinary request within existing
  permissions, or refused.
- Client: the Channels area, a thread session shown as a chat, an approval
  granted and recorded.

## Rollout

After the workbench daemon (#9) and the agent runtime (#10): a mention is worth
nothing until an agent can actually run. Slack first, one more surface second,
and the contract is judged by how little the second one costs.

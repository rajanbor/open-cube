# Workbench shell specification

## Layout

1. Top bar: brand and workspace menu, version control menu (branch, head,
   recent commits, pinned model versions), chat model picker, a cost chip that
   is also the period picker, and the panel toggles. Appearance is not here: it
   lives in Settings, and the account menu links to it. In the native window it is also the drag region and leaves room
   for the traffic lights.
2. Sidebar: one navigation column, and the only one. At its top, what you can
   start — New chat — then the areas as rows: Projects, Agents, Search, Source
   control, Sandboxes, Models, Workflows. Below them, whichever area is open,
   in collapsible sections with live state on every row. Agents keeps the
   workbench chat pinned above it, and the open agent lists its chats under
   itself with a control to start another; chats never move into a tab strip
   beside the chrome. The account sits at the foot with settings beside it.
   The column is resizable and hides with `⌘B`.
4. Work area: tabs held in groups. Every surface — chat, canvas, sandbox,
   model, usage, agent, agent studio, settings — opens as a tab with its own
   icon, and any tab can be split to the right so two groups sit side by side,
   each with its own strip and its own focus. A tab is dragged between groups;
   an emptied group folds away, and the last one shows a watermark. Opening
   something already open focuses it instead of repeating it.
5. Terminal dock: bottom panel with one tab per sandbox terminal, resizable and
   dismissible without losing its buffer.
6. Right rail: the workbench API — values, functions, modules and the inspector
   policy, each in a collapsible section. Starts closed, like the dock.
7. Status bar: branch, sandbox, running agents, state source and cost. Five
   facts; the rest belongs to Usage.

`⌘K` command palette · `⌘B` sidebar · `⌘J` terminals · `⌘I` right rail ·
`⌘\` split the open tab · `⌘W` close it · `⌘1`–`⌘7` the areas.

The arrangement — one column, then groups of tabs — keeps what VS Code is right
about, which is that everything here is an object worth reading next to another
object, and drops what makes it loud. One list to read, not a grid of icons
beside a list.

## Required interactions

- Open a chat with the in-app inspector or with any agent, and read on every
  answer which model, which version, how many tokens and what it cost.
- Move between an agent, its sandbox, its model and its spend without losing
  the selection, and keep two of them open side by side.
- Inspect a sandbox as a boundary drawing: machine, user account, mounts,
  network policy, processes and attached agents.
- Edit a workflow on the canvas: drag, rename, link, delete, pan, zoom, reset.
- Run engine-backed commands in a terminal pane; be refused, with a reason, for
  anything that needs a live pty.
- Open several terminals at once on a board, each in a chosen sandbox, and
  start an agent session inside one by typing the program's name — with the
  standing-in model, its tokens and its cost stated on every answer.
- Read the workbench API — values, functions, modules — and the scopes the
  in-app model is granted or refused.
- Design an agent: project, model and sandbox in basic mode; instructions,
  patterns, skills, MCP servers and tools in the editor, each chosen from a
  library that explains what it does and what it requires.

## Starting

An empty chat is one mark, one question naming the workspace, and four cards.
The composer carries its context above the field — workspace, state source,
branch — and beside the send control it shows the scope it runs under and the
model that will answer. Explanation belongs in those four cards, not in a
paragraph.

## Disclosure

Sidebar rows are one line; counts, timestamps and answer provenance appear on
hover; refusals and redactions are always visible. Nothing may shift layout when
it appears. See `.ai/adr/007-quiet-shell-and-native-window.md`.

## Boundaries

The shell renders engine state and never invents an object. Controls for
capabilities that are not implemented say so instead of failing silently. The
application chrome is not dockable; the dockable panel model in
`.ai/specs/DOCKING_LAYOUT.md` applies to the session work surface.

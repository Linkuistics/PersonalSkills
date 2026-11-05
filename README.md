# PersonalSkills

PersonalSkills holds Antony Blakey's personal agent skills. It ships three
craft skills and the `guardrail` skill as two Claude Code plugins. The skills
came from the `linkuistics` plugin of
[Grove](https://github.com/Linkuistics/grove).

## Craft skills

| Skill | Purpose |
| --- | --- |
| `machine-environment` | States the owner's macOS development and configuration contract: mise tool selection, Taskfile workflows, mise bootstrap and the Obsidian operating manual |
| `using-jujutsu` | Drives version control through Jujutsu in a jj-enabled repository, and through Git elsewhere |
| `authoring-conventions` | States the house conventions for authoring a `SKILL.md`. Only a human starts it, with `/authoring-conventions` |

A craft skill is guidance that a session of any kind can use. No Grove mandate
names it.

`machine-environment` carries `assumes-personal-setup: true`. It names the
owner's own machine configuration, so it is misleading on another machine.
Grove's manual installer reports it.

## The guardrail plugin

`guardrail` is a user-invoked safety skill for Claude Code. `/guardrail` turns
it on for the session. Its frontmatter installs a `PreToolUse` hook, which asks
for confirmation before a destructive shell command and before an edit outside
the project boundary. The hook never refuses a tool call.

The mechanism works only in Claude Code, so `guardrail` is a native plugin and
not a Ravel skill. No Ravel root of this repository reaches it.

## Layout

```text
PersonalSkills/
├── LICENSE                    Apache-2.0
├── README.md
├── Taskfile.yml               the checks of the pack
├── scripts/
│   └── check-frontmatter.sh
└── plugins/
    ├── personal/              Ravel source directory and plugin root
    │   ├── .claude-plugin/plugin.json
    │   ├── PROVENANCE.md
    │   └── craft/             the only Ravel root
    │       ├── authoring-conventions/
    │       ├── machine-environment/
    │       └── using-jujutsu/
    └── guardrail/             plugin root, outside every Ravel root
        ├── .claude-plugin/plugin.json
        ├── PROVENANCE.md
        └── skills/guardrail/
```

The source directory is `plugins/personal`. It is the Claude Code plugin root
of the `personal` plugin and the Ravel source directory. Its only root is
`craft`, and it has no `skills/` directory. The manifest lists
`"skills": ["./craft/"]`, so Claude Code scans `craft/` beside its default
`skills/`.

The `guardrail` plugin root is `plugins/guardrail`. It holds
`skills/guardrail/`, because the frontmatter hook of the skill names
`${CLAUDE_PLUGIN_ROOT}/skills/guardrail/scripts/guardrail-hook.sh`. Claude Code
scans `skills/` by default, so the manifest names no skill directory.

The repository root holds the files that the plugins do not deliver: this
README, the licence, the Taskfile and the frontmatter check. Grove's external
pack contract, `docs/specs/external-pack-contract.md` in the Grove repository,
states the layout and the references between skills.

## Plugin names

- `personal` is the Ravel source ID of this repository in Grove's owner design,
  `docs/specs/owner-skill-delivery.md`. One name then identifies the pack on
  both routes, as `research`, `design` and `writing` do for the other packs.
- `guardrail` is the name that the native residue of that design gives the
  plugin. The plugin holds only the skill of that name. Under a native
  installation the skill is `guardrail:guardrail`.

## The dependency

The `personal` plugin declares the `guardrail` plugin in its `dependencies`.
A native user of Grove's `linkuistics` plugin receives `guardrail` with the
personal skills. The dependency keeps that for a native user of the `personal`
plugin, as the `writing` plugin keeps its hooks plugin. A Ravel user takes the
craft skills from the `personal` source and enables only the `guardrail`
plugin.

`guardrail` is user-invoked. Its description therefore costs no context in a
session that does not start it.

## Install

### Ravel

Add this record to the `skills.sources` list of the Ravel settings. Replace
`<checkout>` with the absolute path of a checkout of this repository:

```json
{ "id": "personal", "type": "local", "path": "<checkout>/plugins/personal", "roots": ["craft"] }
```

Ravel reads the checkout as a local directory. It does not fetch or update the
checkout. A tool outside Ravel holds the checkout at a published commit.

For `guardrail`, install the `guardrail` plugin in Claude Code, as the next
section states.

### Claude Code plugins

Grove's marketplace lists these plugins after the Grove change that removes
the `linkuistics` plugin. Then install them as follows:

```text
/plugin marketplace add Linkuistics/grove
/plugin install personal@linkuistics
```

The installation of `personal` also installs `guardrail`. To install only the
guardrail, run `/plugin install guardrail@linkuistics`.

### Manual installation

Grove's manual installer links the craft skills into Codex, Gemini CLI and Pi:

```sh
<grove checkout>/plugins/install.sh --pack <personal checkout>/plugins/personal
```

Until the Grove change that removes the `linkuistics` plugin, Grove ships its
own copies of these skills. The installer refuses a skill name that two
scanned plugins ship. A Grove checkout that still holds those copies therefore
does not install this pack.

## Checks

Run every check of the pack:

```sh
task check
```

- `task check:plugin` checks both plugins with `claude plugin validate`. It
  skips when Claude Code is not installed.
- `task check:frontmatter` checks that each skill declares `harnesses:`.
  Grove's installer reads that key. The task also checks that
  `authoring-conventions` and `guardrail` keep
  `disable-model-invocation: true`.
- `task check:guardrail-test` runs `guardrail-hook.test.sh`.
- `task check:shellcheck` lints both guardrail scripts and the frontmatter
  check with ShellCheck.

The pack holds no kind skill and no rules manifest. Grove's conformance reads
only kind skills, so the checks need no Grove checkout.

## Tool requirements

| Skill or check | Tools |
| --- | --- |
| `machine-environment` | mise, Task and the owner's Obsidian manual |
| `using-jujutsu` | Jujutsu (`jj`), and Git in a colocated repository |
| `authoring-conventions` | None |
| `guardrail` | Claude Code, Bash and `jq` |
| `task check` | Task, Bash, `jq` and ShellCheck. Claude Code for `check:plugin`, which skips when Claude Code is not installed |

## Provenance

The skills come from Grove commit `4cfac62958815219ba5a71941674244a05ff9b56`,
at these paths:

- `plugins/linkuistics/skills/machine-environment/SKILL.md`
- `plugins/linkuistics/skills/using-jujutsu/`, with `SKILL.md` and two files in
  `references/`
- `plugins/linkuistics/skills/authoring-conventions/SKILL.md`
- `plugins/linkuistics/skills/guardrail/`, with `SKILL.md`,
  `scripts/guardrail-hook.sh` and `scripts/guardrail-hook.test.sh`

Grove keeps the full history of these files. This repository imports none of
it. The move made these changes:

- `using-jujutsu` names `using-git-worktrees` by its bare name, where it named
  `superpowers:using-git-worktrees`. Grove's external pack contract forbids a
  plugin-qualified name in pack text.
- `plugins/personal/PROVENANCE.md` holds the authoring table and the section of
  `using-jujutsu` from Grove's `plugins/linkuistics/PROVENANCE.md`.
  `plugins/guardrail/PROVENANCE.md` holds the section of `guardrail`. Each
  skill links to `../../PROVENANCE.md`, which is the file of its own plugin.

No other byte of a moved file changed, and each file keeps its Git mode.

`authoring-conventions` says "this marketplace" and "this repo". In Grove
those words named Grove's marketplace and repository. The words stay. "This
marketplace" names the Linkuistics marketplace, which lists this pack. "This
repo" names the repository whose skill the author edits. The skill does not
apply to one repository only.

The claims of `authoring-conventions` about Grove's `install.sh` and
`install.test.sh` describe Grove's installer, which also installs this pack.
This repository's `check:frontmatter` holds the check of `harnesses:` for its
own skills.

## Licence

PersonalSkills uses the Apache License 2.0, as Grove does. The `LICENSE` file
holds the full text.

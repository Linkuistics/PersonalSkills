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
No installer reads the key. It warns a reader of the skill.

## The guardrail plugin

`guardrail` is a user-invoked safety skill for Claude Code. `/guardrail` turns
it on for the session. Its frontmatter installs a `PreToolUse` hook, which asks
for confirmation before a destructive shell command and before an edit outside
the project boundary. The hook never refuses a tool call.

The mechanism works only in Claude Code, so `guardrail` is a native plugin and
not a Ravel skill. No Ravel root of this repository reaches it. The `personal`
formula carries the plugin and a Claude Code marketplace file that lists it.

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
  plugin. The plugin holds only the skill of that name. Its harness identity
  is `guardrail@personal`, and in a session the skill is
  `guardrail:guardrail`.

## The dependency

The `personal` plugin declares the `guardrail` plugin in its `dependencies`.
A native user of Grove's former `linkuistics` plugin received `guardrail` with
the personal skills, and the dependency recorded that. No route installs the
`personal` plugin now, so its manifest is layout metadata. Ravel delivers the
craft skills from the `personal` source, and the user registers only the
`guardrail` plugin.

`guardrail` is user-invoked. Its description therefore costs no context in a
session that does not start it.

## Install

### Skills

Install the `personal` formula with Homebrew:

```sh
brew tap Linkuistics/taps
brew install personal
```

The formula pins one commit of this repository. Its keg holds the source
directory `plugins/personal` at `share/ravel/skills/personal`, and Homebrew
links it into `$(brew --prefix)/share/ravel/skills/`. The keg also holds
`plugins/guardrail` at `libexec/plugins/guardrail`, and the Claude Code
marketplace file `personal` at its root.

Ravel delivers the skills. Ravel 2.0.0 reads that directory when its settings
name no sources, and it gives each session that it starts the skills of the
root `craft`. `brew upgrade` keeps the pack current. No harness finds the
skills in the keg alone, and this pack has no native marketplace entry or
installer step for its skills.

### The guardrail hook adapter

Ravel installs no hook. Register `guardrail` in Claude Code once, with these
documented commands:

```sh
claude plugin marketplace add "$(brew --prefix)/opt/personal"
claude plugin install guardrail@personal
```

Claude Code stores the marketplace by the stable `opt` path and runs the
plugin in place. An upgrade of the formula therefore needs no new command.
`guardrail` exists only for Claude Code.

### Development

A checkout of this repository can serve as a trial source. Name
`<checkout>/plugins/personal` with the root `craft` in the `skills` object of
the Ravel settings. Ravel captures the uncommitted changes of the checkout.
It does not fetch or update the checkout.

## Checks

Run every check of the pack:

```sh
task check
```

- `task check:plugin` checks both plugins with `claude plugin validate`. It
  skips when Claude Code is not installed.
- `task check:frontmatter` checks that each skill declares `harnesses:`.
  No installer reads that key, and the check keeps it present as metadata.
  The task also checks that
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

`authoring-conventions` said "this marketplace" and "this repo". In Grove
those words named Grove's marketplace and repository. The commit for Homebrew
installation changed "this marketplace" to "the Linkuistics skill packs",
because no marketplace lists the packs now. "This repo" stays. It names the
repository whose skill the author edits, and the skill does not apply to one
repository only.

The same commit changed the claim of `authoring-conventions` that Grove's
`install.sh` reads `harnesses:` and that `install.test.sh` checks it. The skill
now states that no installer reads the key. This repository's
`check:frontmatter` holds the check of `harnesses:` for its own skills. The
commit also made this README state Homebrew installation and Ravel delivery.

## Licence

PersonalSkills uses the Apache License 2.0, as Grove does. The `LICENSE` file
holds the full text.

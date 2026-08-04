# mirror-tailwindlabs

OCX mirrors for [Tailwind Labs](https://github.com/tailwindlabs) tooling. One
repository, one spec directory per package.

| Package | Spec | Publishes to | Announced as |
|---|---|---|---|
| Tailwind CSS | [`tailwindcss/mirror.yml`](tailwindcss/mirror.yml) | `ghcr.io/ocx-contrib/tailwindlabs/tailwindcss` | [`ocx.sh/tailwindlabs/tailwindcss`](https://index.ocx.sh/tailwindlabs/tailwindcss) |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

## Layout

`mirror-base.yml` at the root holds the repo-wide policy every spec inherits
via `extends:` — including the platform matrix and the libc measurement
transcript behind it. `extends:` is a **shallow** merge: a spec that sets a
top-level key replaces that block whole, so `tailwindcss/mirror.yml`
deliberately does not restate `platforms:`.

## What is mirrored

The **standalone CLI** only: upstream ships it as a bare, uncompressed
executable per platform (`tailwindcss-linux-x64`, `tailwindcss-windows-x64.exe`
…), not as an archive. The npm package is out of scope.

Only the **v4 line** is mirrored (`versions.min: 4.1.0`). The still-maintained
v3.4.x line has an incompatible asset matrix — no musl builds, but a
`windows-arm64` and a `linux-armv7` that v4 lacks — and it interleaves by
publish date with v4 (v3.4.19 shipped after v4.1.17). Version selection is by
parsed semver, so the floor keeps it out regardless of dates.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `tailwindcss/mirror.yml` | hand | `ocx-mirror package pipeline generate ci --spec tailwindcss/mirror.yml` |
| `tailwindcss/tests/smoke.star` | hand | — |
| `tailwindcss/metadata*.json`, `tailwindcss/CATALOG.md`, `logo.*` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

`--spec` **appends** rather than replaces, so the regenerate command must name
every spec in the repository.

The repo root is inferred from the enclosing git repository, so `--repo-root`
is needed only when generating outside a checkout.

CI fails on drift via `ocx-mirror package pipeline generate ci --check`.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index PR from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of
scope; see [`NOTICE.md`](NOTICE.md).

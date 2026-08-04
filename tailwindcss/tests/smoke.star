# tailwindcss/tests/smoke.star — stable across upstream releases.
#
# The v4 standalone CLI is a Bun-compiled single-file build of the whole
# Tailwind toolchain: the CSS source that `@import "tailwindcss"` resolves, the
# Rust class scanner that `@source` drives, and the CSS code generator are all
# embedded in this one executable. So a real compile is the only assertion that
# reaches them — `--version` / `--help` short-circuit before any of it.
#
# Every assertion below was measured against the x86_64 asset of ALL 28
# in-range releases (v4.1.0 … v4.3.3): compile exit 0, semver on stderr,
# `.mx-auto` emitted exactly once, malformed input exit 1 with no output file.
#
# Branch on the typed constant; ocx.platform() was removed.
TOOL = "tailwindcss.exe" if ocx.target_platform.os == ocx.os.Windows else "tailwindcss"

# HOME is pinned to scratch as insurance for container legs where it is unset
# or unwritable — MEASURED not load-bearing here (identical output and exit
# with HOME unset and with HOME redirected; the tool writes nothing under it).
# NO_COLOR is set because it is the documented standard, but MEASURED IGNORED:
# tailwindcss emits SGR on its error path regardless (8 ESC bytes with and
# without it). The error-path assertions below therefore never compare a
# multi-word plain substring — they use the exit code and a file side effect,
# both of which colorization cannot touch.
ENV = {"HOME": ocx.scratch_root, "NO_COLOR": "1"}

# ─── Tier 1 + 2 + 3: one real compile ───────────────────────────────────────
#
# `source(none)` disables automatic source detection, so the ONLY place the
# scanner may find a class is the template named by `@source`. Nothing in
# in.css mentions `mx-auto`: the utility can appear in the output only if the
# binary actually read tpl.html and generated the rule for it. A stub that
# copied its input, or a bundle whose embedded CSS source was truncated, emits
# nothing to count.
ocx.write_file("tpl.html", "<div class=\"mx-auto text-3xl\"></div>\n")
ocx.write_file("in.css", "@import \"tailwindcss\" source(none);\n@source \"./tpl.html\";\n")

# stdin="" closes the child's stdin: without `-i` this CLI reads a stylesheet
# from stdin, so an inherited open stdin is the one way it could block.
r = ocx.run(TOOL, "-i", "in.css", "-o", "out.css", env = ENV, stdin = "")
expect.ok(r)

# Version SHAPE only — the banner reads `≈ tailwindcss v4.3.3` on stderr and
# the digits are the contract. Never the word, never the exact version.
expect.matches(r.stderr, r"\d+\.\d+\.\d+")

# The computed artifact. Counts, not substring presence: a rule emitted twice
# is as wrong as one never emitted.
css = ocx.read_file("out.css")
expect.eq(css.count(".mx-auto"), 1)
expect.eq(css.count("margin-inline: auto"), 1)
expect.eq(css.count(".text-3xl"), 1)

# ─── Negative control ───────────────────────────────────────────────────────
#
# The check above is shaped like a passthrough, and a tool that merely copied
# its input would fail it — but only because of what it did NOT emit. This
# pairs it with the other direction: broken CSS must be REJECTED. Exit 1 is
# measured on every in-range version and is positive, so it needs no
# unix/windows branch (only negative codes differ across platforms).
ocx.write_file("bad.css", "@import \"tailwindcss\" source(none);\n.broken { color: \n")
r_bad = ocx.run(TOOL, "-i", "bad.css", "-o", "bad.out.css", env = ENV, stdin = "")
expect.eq(r_bad.exit_code, 1)

# And it must not leave a half-written stylesheet behind. Colorless, so the
# unsuppressable SGR on the error path cannot reach this assertion.
expect.false(ocx.exists("bad.out.css"))

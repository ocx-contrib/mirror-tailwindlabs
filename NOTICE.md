# NOTICE

This repository packages and redistributes upstream software published by
[Tailwind Labs, Inc.](https://github.com/tailwindlabs). The Apache-2.0 license
in [`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

The logo in this repository reproduces the **upstream project's own mark**
(the Tailwind CSS wave, `#38BDF8`, taken unmodified from
`.github/logo-light.svg` in the upstream repository and cropped to the mark) at
512 px, solely to identify the software being mirrored. No endorsement or
affiliation is implied, and no trademark right is claimed.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `tailwindcss` | `ghcr.io/ocx-contrib/tailwindlabs/tailwindcss` | `MIT` |

---

## `tailwindcss`

Upstream: <https://github.com/tailwindlabs/tailwindcss>
Published to `ghcr.io/ocx-contrib/tailwindlabs/tailwindcss`.

| Component | SPDX | Holder |
|---|---|---|
| Tailwind CSS standalone CLI (`tailwindcss`) | **MIT** | Copyright (c) Tailwind Labs, Inc. |

The MIT License grants redistribution of the software in source and binary form
without restriction, on the single condition that the copyright notice and the
permission notice accompany all copies or substantial portions of the software.

Upstream ships the standalone CLI as a **bare executable** with no sidecar
files, so — unlike an archive mirror, where upstream's own `LICENSE` travels
inside the redistributed bytes — there is nothing in the asset itself to carry
the notice. The condition is met instead by reproducing it in full here, by the
`org.opencontainers.image.licenses: MIT` annotation written onto every
published image index, and by this file travelling with the mirror repository
that publishes them:

```
MIT License

Copyright (c) Tailwind Labs, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

The published executables statically link third-party JavaScript and Rust
dependencies under permissive licenses, enumerated in the `pnpm-lock.yaml` and
`Cargo.lock` of the tagged upstream source for each mirrored version.

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.

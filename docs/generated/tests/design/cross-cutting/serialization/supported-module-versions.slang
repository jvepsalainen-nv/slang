//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/serialization.md#versioning-and-backwards-compatibility
//META: purpose=The reader accepts a bounded range of serialization versions rather than only the newest one, and -get-supported-module-versions prints that minimum and maximum.
//META: intent=functional
//META: pipeline_stage=link
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the promise of keeping older modules loadable is backed
// by a version window the build publishes, not just by an internal
// constant. -get-supported-module-versions is a CLI probe that needs no
// input file; the CHECKs require both the minimum and the maximum line
// to be present with an integer on each. The integers move whenever the
// serialized schema changes, so they are matched as wildcards - the
// stable property under test is that a range is reported at all.

//TEST:SIMPLE(filecheck=CHECK): -get-supported-module-versions

// The compiler never reads this file; the probe takes no source input.

// CHECK: Minimum supported version: {{[0-9]+}}
// CHECK-NEXT: Maximum supported version: {{[0-9]+}}

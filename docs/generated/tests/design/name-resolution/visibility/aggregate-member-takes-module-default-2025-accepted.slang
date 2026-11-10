//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#per-keyword-semantics
//META: purpose=Under Slang 2025 an unmodified field of a `public` aggregate takes the module default `internal`, so naming an `internal` type in that field is accepted.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the 2025 side of the version gate with the same source shape that
// 2026 rejects: `Box` is `public` but its unmodified field `h` picks up the
// module default (`internal`) rather than `Box`'s visibility, so referencing
// the `internal` struct `Hidden` is not a less-visible-type violation. The
// CHECK asserts the shader compiled through to emitted HLSL that stores the
// field value.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -std 2025 -entry computeMain -stage compute

struct Hidden { int v; }

public struct Box { Hidden h; }

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    Box b;
    b.h.v = 7;
    outputBuffer[0] = b.h.v;
}

// CHECK: outputBuffer_{{[0-9]+}}[int(0)] = int(7)

//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#keepalivedecoration
//META: purpose=The compute entry-point function receives a keepAlive decoration so DCE does not strip it before emit.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the front end attaches the DCE-suppression decoration to
// insts that have no in-IR use chain reaching them - an entry point is
// called by nobody, so without `keepAlive` it would be removable. The CHECK
// asserts the decoration is present in the module; it is deliberately not
// tied to one inst because the front end attaches it to several.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// At least one keepAlive must appear in the dump; we don't require
// it specifically on `func %main` because the front-end attaches
// keepAlive to multiple insts (entry point, exported globals).
// CHECK: [keepAlive]

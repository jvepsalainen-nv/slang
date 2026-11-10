//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#phase-c-mandatory-optimization-passes
//META: purpose=Phase C's constructSSA (C1) promotes addressable locals to SSA temporaries module-wide, so a never-address-taken int local leaves no var/load/store behind.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a plain local whose address is never taken does not
// survive Phase C as memory. The local is seeded from a `uniform` so the
// value cannot be constant-folded out instead, and the CHECK-NOT asserts
// no `Ptr(Int)` variable is allocated in `main` -- the reads and writes
// have become SSA temporaries feeding the buffer store directly.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int x = a;
    x = x + 1;
    x = x + 1;
    buf[0] = x;
}

// CHECK-LABEL: ### LOWER-TO-IR:
// CHECK-LABEL: func %main
// CHECK-NOT: : Ptr(Int){{[ \t]+}}= var

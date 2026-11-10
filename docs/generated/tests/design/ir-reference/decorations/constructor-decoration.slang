//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#other
//META: purpose=The synthesized struct initializer carries a constructor decoration; the dump prints constructor(true) with a Bool literal operand.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `constructor` marks the function lowered from an `__init`
// declaration and that its operand list is non-empty. An aggregate
// initializer `S { ... }` invokes the struct's synthesized initializer, and
// the CHECK pins the printed operand form `constructor(true)`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

struct S { int x; };

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    S s = { int(tid.x) + 7 };
    buf[0] = s.x;
}

// CHECK: [constructor(true)]

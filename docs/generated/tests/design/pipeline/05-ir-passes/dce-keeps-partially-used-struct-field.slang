//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#ssa-construction-and-basic-cleanup
//META: purpose=Boundary: a local struct whose `.dead` field is written but never read has the dead store collapsed by the SPIR-V cleanup pipeline — the literal initializer 4242 does not survive into SPIR-V.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A partially-dead struct: we write `.live` and `.dead` but only read
// `.live`. The post-link DCE / SSA-simplification pipeline collapses
// the dead store on SPIR-V — the literal `4242` does not survive.
// (HLSL emit keeps the dead store visible textually; this test pins
// only the SPIR-V boundary.) The optimization level is pinned to -O1
// (slangc's default) because slang-test injects -O0 into compiler
// tests that do not name a level, and -O0 deliberately keeps the
// dead store.

//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main -O1

uniform int a;
uniform RWStructuredBuffer<int> buf;

struct Pair { int live; int dead; };

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Pair p;
    p.live = a + 1;
    p.dead = 4242;
    buf[0] = p.live;
}

// SPIRV: OpEntryPoint
// SPIRV-NOT: 4242

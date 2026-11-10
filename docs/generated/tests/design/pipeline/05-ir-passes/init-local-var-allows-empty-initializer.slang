//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#ssa-construction-and-basic-cleanup
//META: purpose=The init-local-var pass inserts default initialization for locals so the SPIR-V emit does not need explicit zero-init for the typical local in a Slang shader.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "Init local var" row of the cleanup category
// (`slang-ir-init-local-var.cpp`) inserts default initialization
// for locals. After the pass runs, a freshly-defaulted struct
// local can be read without triggering the use-uninitialized check.
// (We observe the absence of an error.)

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

struct Pair { int a; int b; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Pair p = {};
    buf[0] = p.a + p.b;
}

// HLSL: void main

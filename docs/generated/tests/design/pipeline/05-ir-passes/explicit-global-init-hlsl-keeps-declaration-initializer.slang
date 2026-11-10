//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#layout-and-binding
//META: purpose=On HLSL, moveGlobalVarInitializationToEntryPoints leaves a scalar static global with its declaration initializer instead of moving it into the entry point.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Explicit global init row says HLSL keeps declaration initializers
// except for arrays, cooperative vectors and selected resource globals.
// The same source on GLSL/WGSL (explicit-global-init-moves-initializer-
// into-entry-point.slang) loses the initializer; here the HLSL emit keeps
// `= int(7)` on the declaration.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

RWStructuredBuffer<int> outBuf;

static int gCounter = 7;

[numthreads(1, 1, 1)]
void main()
{
    gCounter = gCounter + 1;
    outBuf[0] = gCounter;
}

// HLSL: static int gCounter_{{[0-9]+}} = int(7);

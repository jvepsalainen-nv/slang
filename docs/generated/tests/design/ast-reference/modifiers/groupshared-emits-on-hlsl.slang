//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=The `groupshared` storage modifier survives lowering to emitted HLSL.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `groupshared` selects workgroup-shared storage rather than being
// dropped during lowering. The array is written, synchronised and read back so
// it cannot be eliminated, and CHECK asserts the emitted HLSL declares it with
// the `groupshared` storage class.

// Every shader back end has its own name for the same address space -- GLSL
// `shared`, Metal `threadgroup`, WGSL `var<workgroup>`, SPIR-V the `Workgroup`
// storage class -- so each prefix asserts the array landed in workgroup storage
// on that target rather than in a private or global one.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage compute

groupshared int gShared[4];

RWStructuredBuffer<int> outBuf;

[numthreads(4,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    gShared[tid.x] = int(tid.x);
    GroupMemoryBarrierWithGroupSync();
    outBuf[tid.x] = gShared[tid.x];
}

//CHECK: groupshared

//GLSL: shared int  gShared_{{[0-9]+}}[4];
//METAL: threadgroup array<int, int(4)> gShared_{{[0-9]+}};
//WGSL: var<workgroup> gShared_{{[0-9]+}} : array<i32
//SPIRV: %gShared = OpVariable %{{[A-Za-z0-9_]+}} Workgroup

//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#intval-and-why-integer-values-are-first-class-vals
//META: purpose=An integer cast and a symbolic builtin operator each propagate the link-time property through their operand, so an array bound written int(M) / 2 over an extern constant stays unresolved past checking and emits the linked extent.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two propagating forms named alongside the polynomial: the cast
// `int(M)` over a link-time `extern static const uint`, and the division that
// consumes it. Neither node holds the value itself, so each can only report
// itself as link-time by asking its operand; if either dropped the property
// the bound would have to be settled during checking instead. The array bound
// `int(M) / 2` with M = 9 resolves to 4 (integer division truncates), and each
// target's array-declaration syntax spells that resolved extent, so all five
// shader text targets observe the same claim.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry computeMain
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry computeMain
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry computeMain
//TEST:SIMPLE(filecheck=METAL):-target metal -stage compute -entry computeMain
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -stage compute -entry computeMain

extern static const uint M = 9;

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    int data[int(M) / 2];
    for (int i = 0; i < int(M) / 2; ++i) { data[i] = i; }
    outputBuffer[0] = data[int(M) / 2 - 1];
}

// int(9) / 2 == 4 once the link-time value is resolved.
//HLSL: data{{[A-Za-z0-9_]*}}[int(4)]
//SPV: OpConstant %{{[A-Za-z0-9_]+}} 4{{$}}
//GLSL: data{{[A-Za-z0-9_]*}}[4];
//METAL: array<int, int(4)> data
//WGSL: data{{[A-Za-z0-9_]*}} : array<i32, i32(4)>

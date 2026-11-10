//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#global-scope-type-layout
//META: purpose=On CUDA and C++ the global scope is itself a parameter group, so the module-level layout is a parameterGroupTypeLayout even without a user-written cbuffer.
//META: intent=boundary
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the wrapped/unwrapped global-scope branch is target-driven, not
// only syntax-driven. The same source with no `cbuffer` produces a plain
// `structTypeLayout` on SPIR-V but a `parameterGroupTypeLayout` on CUDA and
// C++, where global uniforms are gathered into a generated parameter block.
// The SPV prefix pins the unwrapped shape, CUDA/CPP the wrapped one.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -dump-ir -o - -entry main -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -dump-ir -o - -entry main -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// SPV-LABEL: ### AFTER {{[A-Za-z0-9_]+}}:
// SPV: {{^}}varLayout(
// SPV-NEXT: structTypeLayout(

// CUDA-LABEL: ### AFTER {{[A-Za-z0-9_]+}}:
// CUDA: {{^}}varLayout(
// CUDA-NEXT: parameterGroupTypeLayout(

// CPP-LABEL: ### AFTER {{[A-Za-z0-9_]+}}:
// CPP: {{^}}varLayout(
// CPP-NEXT: parameterGroupTypeLayout(

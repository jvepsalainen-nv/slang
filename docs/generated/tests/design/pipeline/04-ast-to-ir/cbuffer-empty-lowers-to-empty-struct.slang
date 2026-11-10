//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#module-level-outputs
//META: purpose=An empty `cbuffer CB {}` lowers to a `ConstantBuffer(%SLANG_ParameterGroup_CB, ...)` global parameter and a body-less struct type; layout-intent annotation appears later in the pipeline.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: layout-intent marker lower edge — empty cbuffer. The
// doc's "Layout intent on global parameters" note describes the
// global-param-with-layout shape, here at zero fields. The struct
// `%SLANG_ParameterGroup_CB` is declared but carries no
// `field(...)` rows.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

cbuffer CB { }

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = 0;
}

// CHECK: struct %SLANGx5FParameterGroupx5FCB	: Type;
// CHECK: let  %CB	: ConstantBuffer({{.*}})	= global_param

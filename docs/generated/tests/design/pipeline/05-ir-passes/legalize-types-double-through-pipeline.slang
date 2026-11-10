//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=Expansion (boundary): a `double` value routed through the type-legalization pipeline emits `OpCapability Float64` on SPIR-V — wide-type axis to the 16-bit / 8-bit cases.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Wide-scalar axis on legalize-types: 64-bit float requires the
// `Float64` capability on SPIR-V. The legalize pipeline must surface
// this capability requirement.

//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main

uniform double a;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + 1.0;
}

// SPIRV: OpCapability Float64
// SPIRV: OpEntryPoint

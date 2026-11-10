//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#legalizenonstructparametertostructforhlsl
//META: purpose=A non-empty non-struct callable payload on D3D is retyped to a one-field wrapper struct named ForceVarIntoStructTemporarily_t with a data field.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the callable-data arm of the non-struct wrapping: a `callable`
// entry point with an inout `float4` is emitted with the generated
// `ForceVarIntoStructTemporarily_t` wrapper (not a raw float4), whose field
// is `data`. CHECK ties the declaration to the parameter type.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -profile lib_6_6 -stage callable -entry main

[shader("callable")]
void main(inout float4 data)
{
    data.x = 1.0;
}

// CHECK: struct [[WRAP:ForceVarIntoStructTemporarily_t[A-Za-z0-9_]*]]
// CHECK-NEXT: {
// CHECK-NEXT: float4 data{{[A-Za-z0-9_]*}};
// CHECK: [shader("callable")]
// CHECK: void main(inout [[WRAP]] {{[A-Za-z0-9_]+}})

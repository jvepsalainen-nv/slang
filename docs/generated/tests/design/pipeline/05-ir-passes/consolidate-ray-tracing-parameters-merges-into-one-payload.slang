//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#entry-point-and-parameter-handling
//META: purpose=With two or more varying out / inout parameters a ray-tracing entry point has all of them merged into the fields of one anonymous struct, held in a single IncomingRayPayload variable decorated with ray-payload location 0.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two-or-more branch of `consolidateRayTracingParameters`.
// The `miss` entry point takes two separately declared `inout` parameters
// of different types, which the single-parameter path would have given two
// independent variables. The CHECKs assert exactly one payload variable
// exists, that it holds a struct rather than either parameter's own type,
// that it carries location 0, and that each parameter use became a field
// access chain into it — the rewrite the consolidation performs.

//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage miss -entry main

[shader("miss")]
void main(inout float4 colour, inout int hits)
{
    colour = float4(1, 0, 0, 1);
    hits = hits + 1;
}

// One payload variable, holding a struct, at location 0 ...
// SPIRV-DAG: OpDecorate %{{[A-Za-z0-9_]+}} Location 0
// SPIRV-DAG: %{{[A-Za-z0-9_]+}} = OpVariable %_ptr_IncomingRayPayloadKHR__struct_{{[0-9]+}} IncomingRayPayloadKHR
// ... and both parameters reached through field access chains into it.
// SPIRV-DAG: OpAccessChain %_ptr_IncomingRayPayloadKHR_v4float
// SPIRV-DAG: OpAccessChain %_ptr_IncomingRayPayloadKHR_int

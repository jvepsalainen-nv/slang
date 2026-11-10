//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#warning-groups
//META: purpose=Boundary: the groups are independent rather than nested, so `-Wall` does not enable a `pedantic` warning.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the independence of the groups at the boundary a nested model would
// get wrong: under clang/gcc-style nesting `-Wall` would subsume the stricter
// groups. The vertex entry point that 38052 reports is compiled with `-Wall`
// only; CHECK-NOT asserts the pedantic warning is still silent, and CHECK
// asserts the compile itself succeeded.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry vertMain -stage vertex -Wall

struct VOut { float4 color : COLOR; };

VOut vertMain(uint id : SV_VertexID)
{
    VOut o;
    o.color = float4(float(id), 0, 0, 1);
    return o;
}

// CHECK-NOT: E38052
// CHECK-NOT: SV_Position' system value semantic
// CHECK: vertMain

//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#attr-family
//META: purpose=The no_diff modifier on a parameter type produces a no-operand no_diff attribute that marks the type as not contributing to derivatives.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the derivative-exclusion marker attribute. `no_diff float` on a
// parameter is the surface; the CHECK captures the zero-operand attribute
// definition and requires the same id to appear as the attribute operand of an
// `Attributed` type, showing the marker travels with the parameter's type
// rather than as a decoration on the function.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<float> buf;

float helper(no_diff float x)
{
    return x * 2.0;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = helper(float(tid.x));
}

// CHECK: %[[N:[0-9]+]]{{.*}}= no_diff
// CHECK: Attributed({{.*}}, %[[N]])

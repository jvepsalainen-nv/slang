//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#conversions-that-do-not-have-their-own-cost-level
//META: purpose=Under the default language version float4(f2, f) still resolves to the declared (vector<T,2>, T) initializer and duplicates the scalar into the last two components.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the legacy semantics the doc attributes to the still-declared
// three-component vector initializer. The call is given a distinguishable
// scalar so the duplication is visible; CHECK asserts the scalar appears in
// both the z and w components.

//TEST:INTERPRET(filecheck=CHECK):

float4 makeFour(float2 f2, float f)
{
    return float4(f2, f);
}

void main()
{
    float4 v = makeFour(float2(1.0f, 2.0f), 9.0f);
    // CHECK: v=1 2 9 9
    printf("v=%d %d %d %d\n", int(v.x), int(v.y), int(v.z), int(v.w));
}

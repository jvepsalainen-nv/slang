//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#generics
//META: purpose=A generic is explicitly specialized by supplying generic arguments in angle brackets `<>`; an explicitly specialized function may be used as a non-generic function.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that explicit angle-bracket specialization `sumVec<3>(v)` binds the value parameter.
// The generic uses `N` to bound the loop; passing a float3 with explicit `<3>` and checking
// output 6 proves the specialization resolved the correct loop count.

//TEST:INTERPRET(filecheck=CHECK):

float sumVec<let N : int>(vector<float, N> v)
{
    float s = 0.0;
    for (int i = 0; i < N; i++) s += v[i];
    return s;
}

void main()
{
    float3 v = float3(1.0, 2.0, 3.0);
    // CHECK: 6
    printf("%g\n", sumVec<3>(v));
}

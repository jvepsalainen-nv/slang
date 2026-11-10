//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A GenericTypeParamDecl introduces a type parameter usable anywhere a type is expected inside the generic.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the name introduced by `<T>` is a usable type in the parameter
// list, the return type and locals. The generic is instantiated at two
// different types and the CHECK asserts both round-tripped values.

//TEST:INTERPRET(filecheck=CHECK):

T identity<T>(T x) { return x; }

void main()
{
    int   i = identity<int>(11);
    float f = identity<float>(1.5f);
    //CHECK: 11 1.500000
    printf("%d %f\n", i, f);
}

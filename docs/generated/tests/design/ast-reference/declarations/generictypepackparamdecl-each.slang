//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A GenericTypePackParamDecl (`each T`) is a variadic type-pack parameter whose element count is queryable inside the generic.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `each T` declares one parameter standing for a whole pack of
// types. The generic is called with three arguments of different types and
// returns the pack's element count; the CHECK asserts 3, which is only right
// if all three argument types were bound into one pack parameter.

//TEST:INTERPRET(filecheck=CHECK):

int packLen<each T>(expand each T args) { return countof(T); }

void main()
{
    //CHECK: 3
    printf("%d\n", packLen(1, 2.0f, 3u));
}

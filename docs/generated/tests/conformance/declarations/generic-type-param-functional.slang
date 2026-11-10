//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#generics
//META: purpose=A generic function with a type parameter can be implicitly specialized to int and float; the function returns the correct typed value for each instantiation.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a generic type parameter `T` can be instantiated with both `int` and `float`.
// `myIdentity` is called once per type; CHECK lines assert 42 and 3.14, confirming
// independent monomorphization for each instantiation.

//TEST:INTERPRET(filecheck=CHECK):

T myIdentity<T>(T val) { return val; }

void main()
{
    int r = myIdentity(42);
    float f = myIdentity(3.14);
    // CHECK: 42
    // CHECK: 3.14
    printf("%d\n%g\n", r, f);
}

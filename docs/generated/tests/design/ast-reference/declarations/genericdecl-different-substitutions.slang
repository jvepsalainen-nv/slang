//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#genericdecl
//META: purpose=A single GenericDecl can be specialized with different substitutions per use site and each specialization keeps its own storage type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that two specializations of one generic struct are independent
// types rather than a shared one. Values of the `int` and `float`
// instantiations are stored and read back through the generic's method; the
// CHECK asserts both, so a shared storage type would lose one of them.

//TEST:INTERPRET(filecheck=CHECK):

struct Holder<T>
{
    T x;
    T get() { return x; }
}

void main()
{
    Holder<int>   hi; hi.x = 100;
    Holder<float> hf; hf.x = 1.5f;
    //CHECK: 100 1.500000
    printf("%d %f\n", hi.get(), hf.get());
}

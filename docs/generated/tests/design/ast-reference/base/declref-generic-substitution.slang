//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#val-nodebase
//META: purpose=A DeclRefBase names a declaration together with optional generic substitutions, so one generic declaration referenced at two different substitutions yields two different specializations.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a reference to a declaration carries its generic
// arguments with it. The single generic `id` is referenced twice, at
// `int` and at `float`; CHECK asserts each call returns a value of the
// substituted type. If a reference could only name the declaration and
// not its substitution, the two call sites could not disagree about T.

//TEST:INTERPRET(filecheck=CHECK):

T id<T>(T v) { return v; }

void main()
{
    int   i = id<int>(7);
    float f = id<float>(2.5f);
    //CHECK: i=7
    printf("i=%d\n", i);
    //CHECK: f=2.500000
    printf("f=%f\n", f);
}

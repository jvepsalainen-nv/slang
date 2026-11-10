//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#synthesizing-implicit-code
//META: purpose=The synthesized construction path composes, so a struct containing another struct is initializable from a brace list of brace lists.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the composition edge of the synthesis claim: the outer struct's
// synthesized signature must accept an inner initializer list, which requires
// the inner struct's own synthesized constructor to be found during checking
// of the outer one. CHECK asserts every leaf field, so a mis-nested binding
// would show up as a wrong value rather than a silent pass.

//TEST:INTERPRET(filecheck=CHECK):

struct Inner
{
    int a;
    int b;
}

struct Outer
{
    Inner inner;
    int c;
}

void main()
{
    Outer o = { { 1, 2 }, 3 };
    // CHECK: a=1 b=2 c=3
    printf("a=%d b=%d c=%d\n", o.inner.a, o.inner.b, o.c);
}

//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=matchArgumentsToParams lets a brace initializer argument be matched against a struct parameter instead of being rejected outright.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the argument/parameter matching that runs ahead of the per-argument
// coercion check: `take({1, 2})` pairs the brace initializer with the `P`
// parameter rather than treating it as an unmatched argument. CHECK asserts the
// callee saw both field values, which proves the match and the coercion both
// succeeded.

//TEST:INTERPRET(filecheck=CHECK):

struct P { int a; int b; }

int take(P p) { return p.a * 10 + p.b; }

void main()
{
    int v = take({1, 2});
    // CHECK: v=12
    printf("v=%d\n", v);
}

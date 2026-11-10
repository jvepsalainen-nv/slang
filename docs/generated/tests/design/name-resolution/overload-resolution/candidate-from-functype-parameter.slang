//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-where-candidates-come-from
//META: purpose=A parameter whose declared type is spelled with functype takes the function-value candidate path, so an ordinary function name passed as that argument becomes the callee.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the function-valued-parameter candidate family. The parameter is
// declared with the `functype` spelling, so calling it inside the body has to
// resolve against the passed-in function value rather than a declared
// callable; CHECK asserts the sum the passed function computes.

//TEST:INTERPRET(filecheck=CHECK):

int apply(functype(int, int) -> int f, int a, int b) { return f(a, b); }

int addUp(int a, int b) { return a + b; }

void main()
{
    int tag = apply(addUp, 3, 4);
    // CHECK: tag=7
    printf("tag=%d\n", tag);
}

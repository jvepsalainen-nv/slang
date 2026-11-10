//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#partial-generic-application
//META: purpose=A generic candidate whose parameters are all pinned by the call arguments is fully specialized rather than left partially applied.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fully-closed end of the partial-application spectrum: the single
// argument determines T, so no PartiallyAppliedGenericExpr survives and the
// call is an ordinary specialized invocation. CHECK asserts the returned value
// round-trips at the argument's type.

//TEST:INTERPRET(filecheck=CHECK):

T identity<T>(T x) { return x; }

void main()
{
    int v = identity(42);
    // CHECK: v=42
    printf("v=%d\n", v);
}

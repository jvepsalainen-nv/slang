//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#unqualified-lookup
//META: purpose=A variable is not overloadable, so lookup stops the outward scope walk as soon as one is found and a same-named file-scope value is never accumulated.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the short-circuit step of the scope walk for a
// non-overloadable hit. A local `K` and a file-scope `K` both exist;
// if the walk continued outward the reference would collect two
// candidates and diagnose an ambiguity. CHECK asserts the local value
// 7 is what prints, proving the walk stopped at the first scope.

//TEST:INTERPRET(filecheck=CHECK):

static const int K = 999;

void main()
{
    int K = 7;
    // CHECK: r=7
    printf("r=%d\n", K);
}

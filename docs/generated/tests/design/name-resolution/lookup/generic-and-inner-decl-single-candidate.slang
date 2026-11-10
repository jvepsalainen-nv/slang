//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#container-level-overload-accumulation
//META: purpose=The same-name chain skips a generic's inner decl, so a generic and its inner declaration do not both answer to the generic's name and a same-named plain overload still resolves.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented carve-out in the same-name chain: the inner
// decl a generic wraps is deliberately not threaded onto the chain. If
// it were, `pick` at file scope would yield a duplicate candidate for
// the generic and the single-argument call would have to choose
// between identical entries. CHECK asserts 6, the plain overload's
// result, which requires the call to resolve without ambiguity.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int x) { return x + 1; }

int pick<T : IArithmetic>(T x, T y) { return 100; }

void main()
{
    // CHECK: r=6
    printf("r=%d\n", pick(5));
}

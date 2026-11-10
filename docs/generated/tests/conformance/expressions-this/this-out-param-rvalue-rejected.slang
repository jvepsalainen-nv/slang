//META: generated=true
//META: doc_ref=docs/language-reference/expressions-this.md#mutability
//META: purpose=Passing an r-value expression as an `out` parameter argument is rejected: `out` arguments must be l-values.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an r-value expression cannot be passed to an `out` parameter.
// `makeVal()` returns a temporary (r-value); passing it to `fill(out int x)` must
// be rejected at compile time. CHECK confirms E30047 fires at the call site,
// proving the l-value requirement for `out` arguments is enforced.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void fill(out int x) { x = 42; }
int makeVal() { return 5; }

void main()
{
    fill(makeVal());
//CHECK:        ^ argument must be l-value
}

//META: generated=true
//META: doc_ref=docs/language-reference/expressions-this.md#mutability
//META: purpose=Passing an r-value expression as an `inout` parameter argument is rejected: `inout` arguments must be l-values.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an r-value cannot be passed to an `inout` parameter.
// `makeVal()` is a call expression (r-value); passing it to `addOne(inout int x)`
// must be rejected at check time. CHECK asserts E30047 fires, confirming the
// l-value requirement covers `inout` arguments, not just `out`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void addOne(inout int x) { x = x + 1; }
int makeVal() { return 5; }

void main()
{
    addOne(makeVal());
//CHECK:          ^ argument must be l-value
}

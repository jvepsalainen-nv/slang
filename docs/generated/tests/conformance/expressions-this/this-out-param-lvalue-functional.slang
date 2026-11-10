//META: generated=true
//META: doc_ref=docs/language-reference/expressions-this.md#mutability
//META: purpose=Passing an l-value variable as an `out` parameter argument succeeds and the written value is observable.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a named local variable (l-value) can be passed to an `out` parameter
// and that the callee's write is visible to the caller. `fill(v)` sets v to 42;
// CHECK asserts the printf prints 42, which is only reachable if the `out` write
// propagated back through the l-value argument.

//TEST:INTERPRET(filecheck=CHECK):

void fill(out int x) { x = 42; }

void main()
{
    int v = 0;
    fill(v);
    // CHECK: 42
    printf("%d\n", v);
}

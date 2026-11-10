//META: generated=true
//META: doc_ref=docs/language-reference/expressions-this.md#mutability
//META: purpose=Calling a `[mutating]` member function on an l-value variable succeeds and the mutation is observable on the instance.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that calling a `[mutating]` method on a named variable (l-value) succeeds
// and that the mutation is visible on the original instance after the call returns.
// `c.increment()` writes through the implicit `this` l-value; CHECK asserts c.value
// is 11, which is only reachable if the mutation propagated back to the caller.

//TEST:INTERPRET(filecheck=CHECK):

struct Counter
{
    int value;
    [mutating] void increment() { value = value + 1; }
}

void main()
{
    Counter c;
    c.value = 10;
    c.increment();
    // CHECK: 11
    printf("%d\n", c.value);
}

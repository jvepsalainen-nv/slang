//META: generated=true
//META: doc_ref=docs/language-reference/expressions-this.md#mutability
//META: purpose=Calling a `[mutating]` member function on an r-value (temporary) is rejected because the implicit `this` argument must be an l-value.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that calling a `[mutating]` method on a temporary (r-value) is rejected.
// `Counter.make(5)` returns a temporary; chaining `.increment()` on it passes an
// r-value as the implicit `this`. CHECK asserts E30050 fires, confirming the
// compiler enforces the l-value requirement for `[mutating]` receivers.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct Counter
{
    int value;
    [mutating] void increment() { value = value + 1; }
    static Counter make(int v) { Counter c; c.value = v; return c; }
}

void main()
{
    Counter.make(5).increment();
//CHECK:                     ^ mutating method cannot be called on immutable value
}

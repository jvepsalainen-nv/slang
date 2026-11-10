//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#receiver-parameter-modes
//META: purpose=A method without `[mutating]` cannot assign through `this`; the checker diagnoses it.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the default for a struct method is non-mutating, so `[mutating]` is
// load-bearing rather than optional decoration. The method assigns to a field
// with no attribute present and CHECK pins the not-modifiable error code -- the
// same code a write to a `const` produces.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S
{
    int n;

    void bad()
    {
        n = 42;
        //CHECK: error
        //CHECK: E30011
    }
}

void main()
{
    S s;
    s.n = 0;
    s.bad();
}

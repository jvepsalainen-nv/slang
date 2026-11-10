//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#traits
//META: purpose=Assigning a `Ptr<T>` (read-write) value to an `ImmutablePtr<T>` variable without an explicit cast is rejected with E30019.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that assigning a `Ptr<T>` (read-write) to an `ImmutablePtr<T>` without
// an explicit cast is rejected. Declares both types, attempts a bare assignment,
// and checks that E30019 fires; proves the type system enforces the no-implicit-
// conversion rule.
//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target cpp

void main()
{
    int x = 10;
    Ptr<int> rw = &x;
    ImmutablePtr<int> ro = rw;
//CHECK: E30019
}

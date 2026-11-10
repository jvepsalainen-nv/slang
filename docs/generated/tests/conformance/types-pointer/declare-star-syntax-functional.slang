//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=The `T*` declaration syntax creates a pointer-to-T; address-of `&` and dereference `*` work round-trip.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `T*` declares a pointer-to-T and that `&` / `*` round-trip correctly.
// Assigns `int* p = &x`, then reads `*p`; CHECK asserts the value matches
// the original, proving declaration, address-of, and dereference all work together.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 42;
    int* p = &x;
    //CHECK: 42
    printf("%d\n", *p);
}

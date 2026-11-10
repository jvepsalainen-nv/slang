//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=The address-of operator `&` applied to an object yields a pointer whose dereference gives back the original value.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `&obj` produces a pointer to the object.
// Takes the address of a local int, then reads back through the pointer;
// CHECK asserts the printed value equals the original, confirming the
// address-of operator yields a usable, non-stale pointer.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 7;
    int* pa = &a;
    //CHECK: 7
    printf("%d\n", *pa);
}

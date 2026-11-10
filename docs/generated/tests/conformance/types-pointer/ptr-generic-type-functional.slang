//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#generic-pointer
//META: purpose=`Ptr<T>` generic pointer type can be declared, assigned from `&obj`, and dereferenced; yields the same value as a `T*` pointer.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `Ptr<T>` generic type alias is usable as a pointer.
// Declares `Ptr<int> p = &x` and dereferences it; CHECK asserts the
// value read equals the original, confirming the alias behaves like `T*`.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 55;
    Ptr<int> p = &x;
    //CHECK: 55
    printf("%d\n", *p);
}

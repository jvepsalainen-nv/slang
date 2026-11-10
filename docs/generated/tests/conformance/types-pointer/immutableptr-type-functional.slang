//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#generic-pointer
//META: purpose=`ImmutablePtr<T>` is a valid pointer alias; it can be declared via explicit cast from a `T*` and dereferenced to read the value.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `ImmutablePtr<T>` is a usable read-only pointer alias.
// Explicit-casts a `T*` to `ImmutablePtr<int>` and dereferences it;
// CHECK asserts the correct value is read back, proving the alias
// accepts the cast and supports dereference.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 33;
    ImmutablePtr<int> ro = (ImmutablePtr<int>)(&x);
    //CHECK: 33
    printf("%d\n", *ro);
}

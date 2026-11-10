//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=`T*` is equivalent to `Ptr<T, Access.ReadWrite, AddressSpace.Device>`; a value of type `T*` is assignable to the fully-qualified Ptr form and vice versa.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `T*` and `Ptr<T, Access.ReadWrite, AddressSpace.Device>` are the same type.
// Assigns a `T*` value directly to the fully-qualified `Ptr<>` form without a cast;
// CHECK asserts both variables read the same value, confirming the two spellings are
// interchangeable and no conversion is required.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 42;
    int* p1 = &x;
    Ptr<int, Access.ReadWrite, AddressSpace.Device> p2 = p1;
    //CHECK: 42 42
    printf("%d %d\n", *p1, *p2);
}

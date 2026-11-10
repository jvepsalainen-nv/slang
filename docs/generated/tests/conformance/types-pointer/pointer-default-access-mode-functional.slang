//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#traits
//META: purpose=The default pointer access mode is `Access.ReadWrite` and the default address space is `AddressSpace.Device`; `T*` and `Ptr<T, Access.ReadWrite, AddressSpace.Device>` are interchangeable.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `T*` defaults to `Access.ReadWrite` and `AddressSpace.Device`.
// Assigns an `int*` to a `Ptr<int, Access.ReadWrite, AddressSpace.Device>` variable
// without a cast; CHECK asserts both pointers read the same value, proving they are
// the same type under the default parameters.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 123;
    int* star       = &x;
    Ptr<int, Access.ReadWrite, AddressSpace.Device> full = star;
    //CHECK: 123 123
    printf("%d %d\n", *star, *full);
}

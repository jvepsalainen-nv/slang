//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=`__getAddress(obj)` is an alternative to the `&` operator; both yield a pointer whose dereference gives back the original value.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `__getAddress(obj)` is an alternative to `&obj` for obtaining a pointer.
// Calls `__getAddress(x)` and dereferences the result; CHECK asserts the
// read-back value equals the original, confirming the builtin works like `&`.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 77;
    int* p = __getAddress(x);
    //CHECK: 77
    printf("%d\n", *p);
}

//META: generated=true
//META: doc_ref=docs/language-reference/types-array.md#declaration-syntax
//META: purpose=Per Remark 4, arrays in Slang are passed by value — mutating an array parameter inside a callee does NOT propagate back to the caller's array.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc explicitly notes "Unlike in C and C++, array types in
// Slang do not decay to pointer types... array objects are always
// passed as values in assignment and function calls, similar to
// `std::array`." Verify a function that overwrites its array
// parameter does NOT affect the caller's array.

//TEST:INTERPRET(filecheck=CHECK):

void mutate(int x[3])
{
    x[0] = 99;
    x[1] = 99;
    x[2] = 99;
}

void main()
{
    int caller[3] = { 1, 2, 3 };
    mutate(caller);
    //CHECK: caller=1 2 3
    printf("caller=%d %d %d\n", caller[0], caller[1], caller[2]);
}

//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An AlignOfExpr `alignof(T)` yields a compile-time-known alignment in bytes; for `int` the value is 4.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// AlignOfExpr derives from SizeOfLikeExpr and represents `alignof(T)`.
// We pin the value at file scope as `static const int` and print it.

//TEST:INTERPRET(filecheck=CHECK):

static const int al = alignof(int);

void main()
{
    // CHECK: al=4
    printf("al=%d\n", al);
}

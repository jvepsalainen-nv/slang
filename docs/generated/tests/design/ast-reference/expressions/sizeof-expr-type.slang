//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A SizeOfExpr `sizeof(T)` yields a compile-time-known size in bytes; for `int` the layout is 4.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SizeOfExpr is documented to compute `sizeof(T)` / `sizeof(e)`. We
// evaluate it at file scope into a `static const` so the value is
// definitely the compile-time constant; printing it confirms.

//TEST:INTERPRET(filecheck=CHECK):

static const int sz = sizeof(int);

void main()
{
    // CHECK: sz=4
    printf("sz=%d\n", sz);
}

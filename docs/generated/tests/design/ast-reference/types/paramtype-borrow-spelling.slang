//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#nodes
//META: purpose=BorrowInParamType is written __borrow (legacy alias __constref) and is an input-only borrow: the callee reads the caller's value through it.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the new `__borrow` spelling of the immutable borrow parameter
// next to the legacy `__constref` alias: both read the caller's storage and
// both observe the same value.

//TEST:INTERPRET(filecheck=CHECK):

int peekBorrow(__borrow int x) { return x + 1; }
int peekConstRef(__constref int x) { return x + 2; }

void main()
{
    int a = 5;
    // CHECK: borrow=6 constref=7
    printf("borrow=%d constref=%d\n", peekBorrow(a), peekConstRef(a));
}

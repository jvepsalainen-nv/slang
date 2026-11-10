//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#nodes
//META: purpose=A RefParamType parameter (`__ref`) aliases the caller's storage so writes land in it, while a BorrowInParamType parameter (`__constref`, legacy alias of `__borrow`) borrows it read-only.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two borrow-flavoured passing modes against each other.
// The `__ref` callee writes through its parameter and the caller must
// see the new value; the `__constref` callee only reads. CHECK asserts
// 6 after the ref write and 7 for the borrow read, which distinguishes
// an aliasing reference from a by-value copy.

//TEST:INTERPRET(filecheck=CHECK):

void bump(__ref int x) { x = x + 1; }
int peek(__constref int x) { return x + 1; }

void main()
{
    int a = 5;
    bump(a);
    // CHECK: a=6
    printf("a=%d\n", a);
    // CHECK: p=7
    printf("p=%d\n", peek(a));
}

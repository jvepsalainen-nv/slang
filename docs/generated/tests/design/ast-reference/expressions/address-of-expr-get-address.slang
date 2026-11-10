//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that `__getAddress(e)` yields a pointer to the operand's storage, so writes through the pointer are visible in the original variable.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The address-of expression has its own keyword spelling rather than sharing
// the unary `&` operator. A struct local's address is taken, a field is
// written through the resulting pointer, and the original local is read back;
// the CHECK asserts the mutated value, which only appears if the pointer
// aliases the same storage.

//TEST:INTERPRET(filecheck=CHECK):

struct S { int v; }

void main()
{
    S s = { 7 };
    S* p = __getAddress(s);
    (*p).v = 11;
    // CHECK: v=11
    printf("v=%d\n", s.v);
}

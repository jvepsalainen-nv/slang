//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#the-general-path
//META: purpose=operator() is resolved by member lookup on the callee's type, so calling a struct value like a function dispatches to its operator() member.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the member-lookup half of operator dispatch. Unlike infix
// operators, the call form looks operator() up on the callee value's type and
// keeps the implicit this, so the member sees the receiver's field; CHECK
// asserts a result that combines the stored base with the call argument.

//TEST:INTERPRET(filecheck=CHECK):

struct Adder
{
    int base;
    int operator()(int x) { return base + x; }
}

void main()
{
    Adder a;
    a.base = 10;
    int tag = a(5);
    // CHECK: tag=15
    printf("tag=%d\n", tag);
}

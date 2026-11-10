//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#invokeexpr-and-the-call--operator--cast-unification
//META: purpose=Operator application is unified with function call: an overloaded `operator+` on a struct is invoked by writing `a + b`, the same way as a function call.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an operator application dispatches to a user-declared
// `operator+` exactly as a named call would. `a + b` on a struct with a
// user-defined operator is evaluated and the CHECK reads the field the
// operator body computed, which only happens if the operator resolved as a
// call.

//TEST:INTERPRET(filecheck=CHECK):

struct V2 { int x; int y; }

V2 operator+(V2 a, V2 b)
{
    V2 r = { a.x + b.x, a.y + b.y };
    return r;
}

void main()
{
    V2 a = {1, 2};
    V2 b = {10, 20};
    V2 c = a + b;
    // CHECK: c=(11, 22)
    printf("c=(%d, %d)\n", c.x, c.y);
}

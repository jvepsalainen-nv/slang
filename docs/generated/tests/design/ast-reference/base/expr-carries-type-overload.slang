//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#expr-syntaxnode
//META: purpose=Every Expr carries a type filled in by the checker, and that type is what overload resolution dispatches on.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the type the checker attaches to a compound expression
// (not just to a literal) is what drives overload selection. `1 + 2`
// must be dispatched as `int` and `1.0f + 2.0f` as `float`. CHECK
// asserts the two probe overloads that fire; an untyped expression
// could not be routed to either.

//TEST:INTERPRET(filecheck=CHECK):

int which(int v)   { return 1; }
int which(float v) { return 2; }

void main()
{
    // CHECK: int-expr=1
    printf("int-expr=%d\n",   which(1 + 2));
    // CHECK: float-expr=2
    printf("float-expr=%d\n", which(1.0f + 2.0f));
}

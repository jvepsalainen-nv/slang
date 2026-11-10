//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#memberexpr--staticmemberexpr--derefmemberexpr
//META: purpose=A StaticMemberExpr can also name a static method on a type; calling `T.f()` invokes the method without an instance.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a static method can be named through its type and called
// without an instance. `Counter.next()` is invoked twice from a free function;
// the CHECK reads the returned values, which only exist if the type-qualified
// name resolved to the static method.

//TEST:INTERPRET(filecheck=CHECK):

struct Math
{
    static int add3(int x) { return x + 3; }
}

void main()
{
    int v = Math.add3(10);
    // CHECK: v=13
    printf("v=%d\n", v);
}

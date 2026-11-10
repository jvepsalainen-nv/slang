//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#builtinoperatorexpr
//META: purpose=The builtin-operator fast path covers bool scalar operands: `==` and `!=` on bool values yield the expected truth values.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that builtin comparison operators accept bool scalar operands,
// one of the documented operand categories of the fast path. `true == false`
// and `true != false` are evaluated and CHECK asserts the 0/1 results, so
// a mis-mapped operation kind would flip the observed values.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    bool t = true;
    bool f = false;
    // CHECK: eq=0
    printf("eq=%d\n", int(t == f));
    // CHECK: ne=1
    printf("ne=%d\n", int(t != f));
}

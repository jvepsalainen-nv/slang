//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A VarDecl is an ordinary mutable variable; its value can be assigned and re-read.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the binding a `VarDecl` introduces is mutable: the local
// declared with an initializer accepts a later assignment. The CHECK asserts
// the second value, which only prints if the assignment took effect rather
// than being rejected or discarded.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 1;
    x = 42;
    //CHECK: 42
    printf("%d\n", x);
}

//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=A NullPtrLiteralExpr `nullptr` denotes the null pointer; assigning nullptr to a void* and comparing equal yields true.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// NullPtrLiteralExpr is listed in the Nodes table as `nullptr`. A
// `void*` initialized to `nullptr` compares equal to `nullptr`,
// confirming the literal's pointer-typed value.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    void* p = nullptr;
    // CHECK: eq=1
    printf("eq=%d\n", int(p == nullptr));
}

//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A `__transparent_block { ... }` parses its contents into the enclosing container and itself becomes an empty declaration.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a transparent block does not introduce a scope of its own. A
// function is declared inside the block and called from module-scope code
// outside it; the CHECK asserts that function's result, which requires the
// declaration to have landed in the enclosing container.

//TEST:INTERPRET(filecheck=CHECK):

__transparent_block { int hidden() { return 17; } }

void main()
{
    //CHECK: 17
    printf("%d\n", hidden());
}

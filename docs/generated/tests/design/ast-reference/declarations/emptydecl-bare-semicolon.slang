//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=An EmptyDecl is a declaration with no content of its own; a bare semicolon at module scope is accepted.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a stray `;` at module scope parses as an empty declaration
// rather than a syntax error. The program still runs; the CHECK asserts the
// entry point's output, which only prints if parsing completed.

//TEST:INTERPRET(filecheck=CHECK):

;

void main()
{
    //CHECK: ok
    printf("ok\n");
}

//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#unparsedstmt
//META: purpose=A function body is captured as raw tokens while declarations are parsed and only turned into a real block later, so a body may name a function declared further down the same file.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the deferred-body parse is user-observable: `caller` calls
// `callee`, which is declared after it. If the body were parsed at the
// position where it appears, the call would not resolve. The CHECK
// asserts the composed result, which requires the later declaration to
// have been visible when the body was finally parsed.

//TEST:INTERPRET(filecheck=CHECK):

int caller()
{
    return callee() + 1;
}

int callee()
{
    return 41;
}

void main()
{
    // CHECK: r=42
    printf("r=%d\n", caller());
}

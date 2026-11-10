//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#statement-keywords
//META: purpose=Boundary: `defer` is a statement keyword whose body is held back to scope exit, so its output lands after the statements that textually follow it.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `defer` is parsed as its own statement keyword and that
// its body is deferred rather than executed in place. The deferred
// `printf` is written first but must print last; CHECK asserts the
// single line "before after", which is only produced if the body ran
// at scope exit.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    defer printf("after");
    printf("before ");
    // CHECK: before after
}

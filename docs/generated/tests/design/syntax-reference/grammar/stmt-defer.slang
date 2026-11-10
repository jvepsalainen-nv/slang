//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`DeferStmt` parses as `'defer' Stmt` and its statement runs after the rest of the enclosing scope.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `defer` production takes a plain Stmt (here a block)
// with no parentheses and no trailing clause. The log digit-appends
// on each step, so the final value records the execution order:
// `12` means the deferred block ran after the statement written below
// it, while `21` would mean it ran where it was written.

//TEST:INTERPRET(filecheck=CHECK):

void record(inout int log)
{
    defer { log = log * 10 + 2; }
    log = log * 10 + 1;
}

void main()
{
    int log = 0;
    record(log);
    // CHECK: log=12
    printf("log=%d\n", log);
}

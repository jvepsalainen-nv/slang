//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#modifier-parsing
//META: purpose=A call to a `[NoDiscard]` function whose result is consumed compiles cleanly and runs — the attribute only errors in result-discarding contexts.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positive path of the [NoDiscard] claim: the doc scopes
// the error to result-discarding contexts, so binding the result to a
// variable must compile and produce the value. The printed value
// proves the attributed function was callable and its result usable.

//TEST:INTERPRET(filecheck=CHECK):

[NoDiscard]
int produce()
{
    return 42;
}

void main()
{
    int v = produce();
    // CHECK: v=42
    printf("v=%d\n", v);
}

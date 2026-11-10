//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#statement-keywords
//META: purpose=`for` is a statement keyword that opens a counted-loop header with init/condition/update clauses.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the canonical `for (init; cond; update) { body }`
// syntax is parsed and executed. Summing 1..3 yields 6.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    for (int i = 1; i <= 3; i = i + 1)
    {
        sum = sum + i;
    }
    // CHECK: sum=6
    printf("sum=%d\n", sum);
}

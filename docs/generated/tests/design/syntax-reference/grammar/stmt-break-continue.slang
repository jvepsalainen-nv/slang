//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`BreakStmt` and `ContinueStmt` parse as bare keyword forms (no label) terminating with `;`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the bare-keyword forms of `break;` and `continue;`. The
// loop skips i==2 (continue) and stops at i==4 (break).

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int sum = 0;
    for (int i = 0; i < 10; ++i)
    {
        if (i == 2) continue;
        if (i == 4) break;
        sum += i;
    }
    // CHECK: sum=4
    printf("sum=%d\n", sum);
}

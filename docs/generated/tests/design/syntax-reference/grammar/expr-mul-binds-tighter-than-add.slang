//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=Precedence: `*` (level 3) binds tighter than `+` (level 4).
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the precedence claim from the doc's ladder. `2 + 3 * 4`
// parses as `2 + (3 * 4) == 14`. A left-to-right grouping would give
// `(2+3)*4 == 20`, which would fail the CHECK.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int r = 2 + 3 * 4;
    // CHECK: r=14
    printf("r=%d\n", r);
}

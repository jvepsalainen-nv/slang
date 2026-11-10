//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=Precedence: unary `-` (level 2) binds tighter than `*` (level 3).
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `-2 * 3` parses as `(-2) * 3 == -6`, not `-(2 * 3)`.
// Both happen to yield -6 in arithmetic, so we distinguish with
// `-2 * -3 == 6` instead; a different grouping would not change the
// result either. Use a side-effecting form: `2 * -3 + 1` parses as
// `(2 * (-3)) + 1 == -5`. If unary `-` were looser, parsing would
// fail (no `2 * -` production at level 3).

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int r = 2 * -3 + 1;
    // CHECK: r=-5
    printf("r=%d\n", r);
}

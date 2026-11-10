//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-5 `<<` binds more tightly than level-6 `<`: `1 << 3 < 10` groups as `(1<<3) < 10` = true (8<10), not `1 << (3<10)` = 2.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The precedence table says `<<`/`>>` are level 5, `<`/`<=`/`>`/`>=` are level 6.
// Level 5 is lower numeric = higher precedence, so `<<` binds before `<`.
// `1 << 3 < 10` groups as `(1<<3) < 10` = `8 < 10` = true.
// Wrong grouping `1 << (3<10)` = `1 << 1` = 2 (integer, not bool).

//TEST:INTERPRET(filecheck=CHECK):

int shift_lt(int a, int b, int c) { return (a << b < c) ? 1 : 0; }

void main()
{
    int result = shift_lt(1, 3, 10);
    // CHECK: shift-over-relational: 1
    printf("shift-over-relational: %d\n", result);
}

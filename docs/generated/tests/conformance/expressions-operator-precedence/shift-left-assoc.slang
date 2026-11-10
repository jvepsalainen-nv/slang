//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-5 `<<`/`>>` are left-associative: `1 << 2 << 1` groups as `(1<<2)<<1` = 8, not `1<<(2<<1)` = 16.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The precedence table says `<<`/`>>` at level 5 have left associativity.
// Left assoc: `a << b << c` = `(a<<b)<<c`.
// `(1<<2)<<1` = `4<<1` = 8.
// Right-associative `1<<(2<<1)` = `1<<4` = 16 — wrong.

//TEST:INTERPRET(filecheck=CHECK):

int shift_left2(int a, int b, int c) { return a << b << c; }

void main()
{
    int result = shift_left2(1, 2, 1);
    // CHECK: shift-left-assoc: 8
    printf("shift-left-assoc: %d\n", result);
}

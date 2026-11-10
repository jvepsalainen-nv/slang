//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-8 `&` binds more tightly than level-9 `^`: `3 & 5 ^ 1` groups as `(3&5)^1` = `1^1` = 0, not `3&(5^1)` = `3&4` = 0 (coincidentally same — use different values).
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The precedence table says `&` (bitwise and) is level 8, `^` (xor) is level 9.
// Level 8 is lower numeric = higher precedence, so `&` binds before `^`.
// Use values where the two groupings differ:
// `6 & 5 ^ 3`: left-assoc `&` first = `(6&5)^3` = `4^3` = 7
//              xor first = `6&(5^3)` = `6&6` = 6.

//TEST:INTERPRET(filecheck=CHECK):

int bitand_xor(int a, int b, int c) { return a & b ^ c; }

void main()
{
    // (6 & 5) ^ 3 = 4 ^ 3 = 7
    // 6 & (5 ^ 3) = 6 & 6 = 6
    int result = bitand_xor(6, 5, 3);
    // CHECK: bitand-over-xor: 7
    printf("bitand-over-xor: %d\n", result);
}

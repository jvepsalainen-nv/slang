//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-7 `==` binds more tightly than level-8 `&`: `3 & 5 == 5` groups as `3 & (5==5)` = `3 & 1` = 1, not `(3&5)==5` = `1==5` = 0.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The precedence table says `==`/`!=` are level 7, `&` (bitwise) is level 8.
// Level 7 is lower numeric = higher precedence, so `==` binds before `&`.
// `3 & 5 == 5` groups as `3 & (5==5)` = `3 & 1` = 1.
// Wrong grouping `(3&5)==5` = `1==5` = 0 (false).
// This differs from the intuitive C/C++ expectation where & has higher precedence
// but matches the table's documented ordering.

//TEST:INTERPRET(filecheck=CHECK):

int bitand_eq(int a, int b, int c) { return a & b == c; }

void main()
{
    // 3 & (5==5) = 3 & 1 = 1
    int result = bitand_eq(3, 5, 5);
    // CHECK: equality-over-bitand: 1
    printf("equality-over-bitand: %d\n", result);
}

//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-10 `|` binds more tightly than level-11 `&&`: `0 | 2 && 1` groups as `(0|2) && 1` = `2 && 1` = true, not `0 | (2&&1)` = `0|1` = 1 (same int value — use different values).
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The precedence table says `|` (bitwise or) is level 10, `&&` is level 11.
// Level 10 is lower numeric = higher precedence, so `|` binds before `&&`.
// Use: `0 | 0 && 1`:
//   `|` first: `(0|0) && 1` = `0 && 1` = false (0)
//   `&&` first: `0 | (0&&1)` = `0 | 0` = 0 (same here)
// Better: `4 | 0 && 0`:
//   `|` first: `(4|0) && 0` = `4 && 0` = false (0)
//   `&&` first: `4 | (0&&0)` = `4 | 0` = 4 (nonzero = true in int context)
// Even better — compare as bool:
//   `4 | 0 && 0` as bool: `(4|0)&&0` = true&&false = false
//                         `4|(0&&0)` = 4|false = 4 != 0 = true (different!)

//TEST:INTERPRET(filecheck=CHECK):

int bitor_logand(int a, int b, int c) { return (a | b && c) ? 1 : 0; }

void main()
{
    // (4|0) && 0 = 4 && 0 = false = 0
    // 4|(0&&0) = 4|0 = 4, nonzero = true = 1 (wrong grouping)
    int result = bitor_logand(4, 0, 0);
    // CHECK: bitor-over-logical-and: 0
    printf("bitor-over-logical-and: %d\n", result);
}

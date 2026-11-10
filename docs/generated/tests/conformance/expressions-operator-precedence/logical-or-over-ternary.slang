//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-12 `||` binds more tightly than level-13 `?:`: `false || true ? 1 : 2` groups as `(false||true) ? 1 : 2` = 1, not `false || (true ? 1 : 2)` = 1 (same here — use distinguishable values).
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The precedence table says `||` is level 12, `?:` is level 13.
// Level 12 is lower numeric = higher precedence, so `||` binds before `?:`.
// `false || false ? 10 : 20`:
//   `||` first: `(false||false) ? 10 : 20` = `false ? 10 : 20` = 20
//   `?:` first: `false || (false ? 10 : 20)` = `false || 20` = true in bool context
//               but 20 as int, then `||` would be type error.
// Simpler: use int 0/1 for logical ops:
// `0 || 0 ? 10 : 20`: `(0||0) ? 10:20` = `false ? 10:20` = 20 (correct)
//                     `0||(0 ? 10:20)` = `0 || 20` = 1 (true), which is 1
// These return different types; use bool context:

//TEST:INTERPRET(filecheck=CHECK):

// Use int parameters (1/0) to avoid slangi bool-parameter passing quirk.
int logor_ternary(int a, int b, int x, int y) { return a || b ? x : y; }

void main()
{
    // (0 || 0) ? 10 : 20 = false ? 10 : 20 = 20
    // Wrong grouping: 0 || (0 ? 10 : 20) = 0 || 20 = 1 (true), not 20
    int result = logor_ternary(0, 0, 10, 20);
    // CHECK: logical-or-over-ternary: 20
    printf("logical-or-over-ternary: %d\n", result);
}

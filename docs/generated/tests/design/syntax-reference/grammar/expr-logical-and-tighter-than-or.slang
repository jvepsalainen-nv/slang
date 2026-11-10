//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=Precedence: `&&` (level 11) binds tighter than `||` (level 12).
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `false || true && false` parses as
// `false || (true && false) == false`. If `||` bound tighter, it would
// parse as `(false || true) && false == false` — but the chosen
// operands distinguish: `true || false && false` is `true` either way,
// while `false || true && true` is `true` both ways. We use
// `true || false && false`: with documented precedence it's
// `true || (false && false) == true || false == true`; with reversed
// precedence it's `(true || false) && false == false`.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    bool r = true || false && false;
    // CHECK: r=1
    printf("r=%d\n", int(r));
}

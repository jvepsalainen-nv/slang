//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#-disambiguation
//META: purpose=Inside an open generic argument list `>` is unavailable as an operator even when parenthesised, while `<` keeps its normal precedence.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `genericDepth` is incremented on entering a generic argument list and is
// never reset for a nested parenthesised subexpression, so `GetOpLevel`
// returns `Precedence::Invalid` for `>` throughout -- the inner `>` closes the
// argument list rather than comparing, and the parse then fails on the
// unexpected `)`. The `<` form on the line above is the control: it takes the
// same shape, keeps its normal precedence, and is annotated with nothing, so
// exhaustive mode asserts the restriction is one-sided.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

struct A<let N : int> { int v; }

static const int gX = 1;
static const int gY = 2;

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    A<(gX < gY)> less;
    A<(gX > gY)> greater;
/*CHECK:
          ^ error E20001
          ^ unexpected '>', expected ')'
              ^ error E20001
              ^ unexpected ')', expected ';'
*/
    gOut[0] = less.v;
}

//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=Negative: assigning a vector<int,4> to a vector<int,2> (narrowing) is rejected by the type checker.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// assigning a vector<int,4> to a vector<int,2> (narrowing) is rejected
// by the type checker. A narrowing assignment from `vector<int,4>` to
// `vector<int,2>` (without explicit cast) fires a type-mismatch
// diagnostic — the inverse of the widening case covered by `vector-
// size-mismatch-negative.slang`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int4 v = int4(1, 2, 3, 4);
    int2 w = v;
//CHECK:     ^ type mismatch in expression
//CHECK:     ^ expected an expression of type 'vector<int,2>', got 'vector<int,4>'
// CHECK: E30019
    buf[0] = w.x;
}

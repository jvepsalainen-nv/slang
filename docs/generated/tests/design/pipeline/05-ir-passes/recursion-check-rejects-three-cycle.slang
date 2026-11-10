//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#linking-and-validation
//META: purpose=Expansion (negative): the check-recursion pass diagnoses a 3-function cycle (A->B->C->A) — alternative input shape to direct or 2-cycle mutual recursion.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Input-shape variation for check-recursion: three functions form a
// cycle A -> B -> C -> A. The pass diagnoses one of the cycle edges.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

int A(int n);
int B(int n);
int C(int n);

int A(int n) { return n <= 0 ? 0 : B(n - 1); }
int B(int n) { return n <= 0 ? 0 : C(n - 1); }
//CHECK:                            ^ recursion not allowed
// CHECK: E55201
int C(int n) { return n <= 0 ? 0 : A(n - 1); }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = A(5);
}

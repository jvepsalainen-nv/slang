//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#severity-levels
//META: purpose=-notes-disable <id> suppresses a note diagnostic while the primary error still renders.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies -notes-disable removes the per-candidate notes (E40011) of an
// overload failure. The error E39999 must still be reported (exit code -1), and
// CHECK-NOT asserts no candidate note is rendered.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute -notes-disable 40011

void f(int a) {}
void f(float a, int b) {}

[numthreads(1, 1, 1)]
void main()
{
    f("x", 1, 2);
}

// CHECK: E39999
// CHECK-NOT: E40011

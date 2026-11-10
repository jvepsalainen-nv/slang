//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#severity-levels
//META: purpose=-notes-disable requires the named diagnostic to be a note, so naming an error id is rejected as unknown.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies -notes-disable rejects a diagnostic that is not a Note. 39999 is an
// error entry, so the option reports E31111 (unknown diagnostic) and exits with
// the command-line error code 1.

//TEST:SIMPLE(filecheck=CHECK,exit-code=1):-target hlsl -entry main -stage compute -notes-disable 39999

void f(int a) {}
void f(float a, int b) {}

[numthreads(1, 1, 1)]
void main()
{
    f("x", 1, 2);
}

// CHECK: E31111

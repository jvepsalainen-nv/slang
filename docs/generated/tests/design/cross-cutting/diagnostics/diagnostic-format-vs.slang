//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#source-locations-and-message-rendering
//META: purpose=With -diagnostic-format vs the sink renders a diagnostic as file(line,col): severity E<id>: message instead of the boxed layout.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the Visual Studio diagnostic format. CHECK-DAG asserts the
// file(line,col) location prefix followed by the severity word and the code, and
// CHECK-NOT asserts the boxed header form with brackets is not produced.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute -diagnostic-format vs

void f(int a) {}
void f(float a, int b) {}

[numthreads(1, 1, 1)]
void main()
{
    f("x", 1, 2);
}

// CHECK-DAG: diagnostic-format-vs.slang({{[0-9]+}},{{[0-9]+}}): error E39999
// CHECK-DAG: diagnostic-format-vs.slang({{[0-9]+}},{{[0-9]+}}): note E40011
// CHECK-NOT: error[E39999]

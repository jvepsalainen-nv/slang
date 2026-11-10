//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=Name lookup also accepts the lower-camel `DiagnosticInfo::name` the generator derives, so `-warnings-disable commaOperatorUsedInExpression` suppresses E41024.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the other spelling the lookup accepts: the lower-camel name derived
// from the kebab-case declaration. The same shader compiled with the camel
// spelling must behave exactly like the kebab-case run; CHECK-NOT asserts no
// unknown-diagnostic error and no surviving warning.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute -warnings-disable commaOperatorUsedInExpression

RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int x = (1, 2);
    buf[0] = x;
}

// CHECK-NOT: E31111
// CHECK-NOT: E41024
// CHECK-NOT: comma operator used in expression
// CHECK: void main

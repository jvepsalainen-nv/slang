//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=Boundary: 39999 is on the intentional shared-code list, so two distinct diagnostics render the same E39999 code.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented exemption from code uniqueness. Two different
// conditions are triggered in one file: a call with no applicable overload and an
// ambiguous call. They are separate entries with separate messages, yet CHECK-DAG
// asserts both render under E39999, which is only possible because that id is
// exempted from the uniqueness rule.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> buf;

int narrow(int a) { return a; }
int narrow(bool a) { return a ? 1 : 0; }

int pick(int a, float b) { return 0; }
int pick(float a, int b) { return 1; }

[numthreads(1, 1, 1)]
void main()
{
    float2 v = float2(1, 2);
    buf[0] = narrow(v) + pick(1, 1);
}

// CHECK-DAG: E39999{{.*}}no overload for 'narrow' applicable to arguments
// CHECK-DAG: E39999{{.*}}ambiguous call to 'pick'

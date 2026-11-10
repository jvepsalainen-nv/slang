//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#function-style-declarations
//META: purpose=The C++-style trailing `const` after a parameter list is rejected with E30443 outside the HLSL dialect.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the optional trailing `const` receiver qualifier is dialect-gated:
// compiled as Slang, the member function is rejected with E30443. The HLSL
// counterpart is decl-func-trailing-const-hlsl.hlsl.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -stage compute -entry main

struct S
{
    int v;
    int get() const { return v; }
};

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void main()
{
    S s;
    s.v = 3;
    outputBuffer[0] = s.get();
}

// CHECK: E30443

//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=A `const` written after a function parameter list is the trailing receiver const: the receiver is read-only, so assigning a member is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `CppStyleTrailingReceiverParamConstModifier` row
// (`int read() const`). The trailing form needs the HLSL-flavored dialect, so
// the directive passes `-lang hlsl`. The method assigns to a member and CHECK
// pins the not-an-l-value code, proving the trailing `const` made `this`
// immutable.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1): -lang hlsl -target hlsl -stage compute -entry main

// CHECK: E30011
struct S
{
    int v;
    void set() const
    {
        v = 1;
    }
};

[numthreads(1,1,1)]
void main()
{
}

//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E36111 (unexpected-capability) - disallowed capability
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=36111
//META: catalog_name=unexpected-capability
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `[require(...)]` only accepts capability atoms that resolve to a usable
// capability. A conformance whose implementation narrows the interface's atom
// set leaves the requirement resolving to a disallowed capability, and the CHECK
// pins that error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage compute -entry main -profile sm_6_0
[require(hlsl, glsl)]
interface IFoo
{
    void f();
}

[require(hlsl)]
struct S : IFoo
{
    void f() {}
}

[numthreads(1,1,1)]
void main() {}

//CHECK: E36111

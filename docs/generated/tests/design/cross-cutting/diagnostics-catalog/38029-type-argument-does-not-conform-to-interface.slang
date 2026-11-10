//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38029 (type-argument-does-not-conform-to-interface) - type argument doesn't conform to interface
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38029
//META: catalog_name=type-argument-does-not-conform-to-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A struct without the required interface is passed as a
// generic type argument.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IFoo { int f(); }
struct S {}

void g<T : IFoo>(T v) {}

void main()
{
    S s;
    g<S>(s);
}

//CHECK: E38029

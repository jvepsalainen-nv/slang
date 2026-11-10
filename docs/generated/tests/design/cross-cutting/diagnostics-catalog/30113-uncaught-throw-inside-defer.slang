//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30113 (uncaught-throw-inside-defer) - 'throw' requires 'catch' inside defer
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30113
//META: catalog_name=uncaught-throw-inside-defer
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `throw` inside `defer` requires a matching local catch.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void f() throws int
{
    defer { throw 1; };
}

void main() {}

//CHECK: 30113

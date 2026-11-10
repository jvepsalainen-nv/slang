//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=Outside HLSL source `class` goes through `ParseClass`, which consumes no generic parameter list, so `class Box<T>` is a parse error.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Counterpart of `decl-class-hlsl-generic.hlsl`: in Slang source
// `ParseClass` reads a name and then expects `{`, so `<` is unexpected.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):

//CHECK: E20001
class Box<T>
{
    T v;
};

void main() {}

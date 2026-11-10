//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=A function with an `out T` parameter has IR type `OutParam(T)`; the callee writes through the parameter with `store`, and the caller passes a `Ptr(T)` from a local `var`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Conversions table lists `outImplicitCast` for "Function-arg
// lowering for `out` parameters", and `inOutImplicitCast` for
// `inout`. When the caller's argument type matches the parameter
// type the cast is not emitted, but the parameter's IR type is
// still `OutParam(<T>)`; this test anchors on that shape.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

void writeOut(out int o)
{
    o = 42;
}

[numthreads(1, 1, 1)]
void main()
{
    int x;
    writeOut(x);
    buf[0] = x;
}

// IR: param %{{.*}}: OutParam(Int)
// IR-LABEL: func %main
// IR: var
// IR: call %writeOut(%{{.*}})

//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#specialization-and-existentials
//META: purpose=A function taking an interface-typed parameter projects it with `extractExistentialType`, `extractExistentialValue` and `extractExistentialWitnessTable`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the existential-projection row, which lists the three
// `extractExistential*` opcodes as the inverse of `makeExistential`. A
// function declared as `float callArea(IShape s)` receives an existential;
// its body has to recover the concrete type, the payload, and the witness
// table separately before it can dispatch. The three CHECKs assert all three
// projections appear on the same existential operand `%s`, which is what
// shows the existential is a packed triple rather than an opaque value the
// callee dispatches on directly.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

interface IShape { float area(); }
struct Sq : IShape { float s; float area() { return s * s; } }

float callArea(IShape s)
{
    return s.area();
}

uniform float a;
uniform RWStructuredBuffer<float> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Sq q;
    q.s = a;
    outbuf[0] = callArea(q);
}

// IR-LABEL: func %callArea
// IR-DAG: = extractExistentialType(%s
// IR-DAG: = extractExistentialValue(%s
// IR-DAG: = extractExistentialWitnessTable(%s

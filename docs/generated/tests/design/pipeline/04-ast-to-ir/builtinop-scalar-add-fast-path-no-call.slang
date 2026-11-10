//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#builtin-operators-bypass-call-lowering
//META: purpose=A builtin scalar `a + b` is emitted directly as one pure `add` inst by the checker fast path; no `call` instruction appears in the lowered body because callable resolution is skipped.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fast-path bypass itself, not just the resulting opcode:
// a recognized builtin `+` on scalar ints must emit `add` directly and
// the body must contain no `call` at all — the operator never goes
// through callable resolution. The CHECK-NOT windows before and after
// the `add` pin the absence of any call in `main`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + b;
}

// CHECK-LABEL: func %main
// CHECK-NOT: = call
// CHECK: = add(%{{.*}}, %{{.*}})
// CHECK-NOT: = call
// CHECK: return_val

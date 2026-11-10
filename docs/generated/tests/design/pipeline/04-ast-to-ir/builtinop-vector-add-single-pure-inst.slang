//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#builtin-operators-bypass-call-lowering
//META: purpose=A builtin `+` on `float3` vector operands takes the checker fast path and lowers to a single pure `add` inst whose result IR type is `Vec(Float, 3 : Int)` — no call instruction.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: operand-shape axis (vector). The fast path recognizes
// vector operators too, so `float3 + float3` must produce one `add`
// whose result type is the vector IR type, with no `call` in the body
// (a call would mean the operator went through callable resolution).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float3 a;
uniform float3 b;
uniform RWStructuredBuffer<float3> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a + b;
}

// CHECK-LABEL: func %main
// CHECK-NOT: = call
// CHECK: Vec(Float, 3 : Int){{.*}}= add(%{{.*}}, %{{.*}})
// CHECK-NOT: = call
// CHECK: return_val

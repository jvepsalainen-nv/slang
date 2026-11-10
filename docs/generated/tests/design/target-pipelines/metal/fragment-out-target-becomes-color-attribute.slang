//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#legalizeirformetal
//META: purpose=A fragment entry point whose color is written through `out float4 : SV_Target` is rewritten into a return struct whose field carries `[[color(0)]]`.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `legalizeShaderOutputParamsForMetal` is dispatched for the
// fragment stage and not only for vertex. Metal models stage outputs as
// fields of the entry point's return struct, so a pointer-typed `out`
// parameter cannot survive to emit; leaving it would reach the emitter as
// a pointer with no mapped address space. CHECK asserts the emitted entry
// point returns a struct whose field carries `color(0)` and that no `out`
// pointer parameter remains in the fragment signature.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage fragment

[shader("fragment")]
void main(float4 pos : SV_Position, out float4 color : SV_Target)
{
    color = float4(pos.x, 1.0, 0.0, 1.0);
}

// CHECK: struct main_Result_{{[0-9]+}}
// CHECK: color(0)
// CHECK: fragment{{.*}} main_Result_{{[0-9]+}} main_0
// CHECK-SAME: position

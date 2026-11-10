//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#per-global-parameter-steps
//META: purpose=Each per-global-parameter step attaches an IRLayoutDecoration to the stub IRGlobalParam, observable as a [layout(%N)] on the global_param in the first post-link IR snapshot.
//META: intent=functional
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the layout-IR module attaches a layout decoration to the
// stub global parameter it materialises for every global shader parameter.
// The dump is taken at the first post-link snapshot, where the layout
// module has already been merged in; CHECK asserts the `buf` global_param
// carries a [layout(%N)] decoration, which is the only place that
// decoration can come from.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK-LABEL: ### AFTER {{[A-Za-z0-9_]+}}:
// CHECK: [layout(%{{[0-9]+}})]
// CHECK: global_param

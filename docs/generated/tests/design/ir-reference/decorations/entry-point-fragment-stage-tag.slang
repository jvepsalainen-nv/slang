//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#entrypoint--entrypointdecoration
//META: purpose=Boundary - a [shader("fragment")] entry point lowers to an entryPoint decoration whose profile integer is 5, the Stage tag for fragment (pixel) in the documented tag table.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented Stage tag table: fragment is 5 (vertex is 1 and
// compute is 6 in sibling tests), so the first operand of `entryPoint` is
// the SlangStage value and not an arbitrary constant.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage fragment

struct VOut { float4 pos : SV_Position; };

[shader("fragment")]
float4 main(VOut i) : SV_Target
{
    return i.pos;
}

// CHECK: [entryPoint(5 : Int, "main", "{{.*}}")]
// CHECK: func %main

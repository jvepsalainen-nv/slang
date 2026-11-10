//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A module-scope `uniform int8_t` lowers with IR type `Int8`; the doc's "VarDecl(global) -> IRGlobalVar" row at the narrow-integer end of the type axis.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: storage axis for the global-VarDecl row, exercising
// `int8_t` as the scalar element type of a `global_param`.
// `uniform` defeats constant folding so the load survives to IR.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int8_t a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(a);
}

// CHECK: [nameHint("a")]
// CHECK: let {{.*}}a{{.*}}: Int8{{.*}}= global_param

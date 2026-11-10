//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A module-scope uniform VarDecl lowers to an `IRGlobalVar` (spelled `global_param` in the IR dump).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc says global `VarDecl` → `IRGlobalVar`. In shader code the
// usual surface for that is a `uniform` declaration, which lowers to
// `global_param` in the IR dump.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int myUniformInt;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = myUniformInt;
}

// CHECK: [nameHint("myUniformInt")]
// CHECK: let {{.*}}myUniformInt{{.*}}: Int{{.*}}= global_param

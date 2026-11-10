//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=`Optional<int>` composes through lowering as `Optional(Int)`; the nested-type axis on a scalar inner type.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion: nested type — `Optional` over a plain scalar type.
// Paired with `lower-optional-half3.slang`, this isolates the
// `Optional<T>` lowering from the half/vector axes.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int x;
uniform int sel;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Optional<int> opt;
    if (sel > 0) { opt = x; }
    if (opt.hasValue) {
        buf[0] = opt.value;
    } else {
        buf[0] = 0;
    }
}

// CHECK-LABEL: func %main
// CHECK: Optional(Int)

//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A StructDecl lowers to an `IRStructType` parent instruction containing `IRStructField` children.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A two-field struct lowers to a `struct %Pair` parent with two
// `field(%<key>, <Type>)` rows — the doc's "StructDecl → IRStructType
// with IRStructField children" claim.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Pair { int x; int y; }

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Pair p;
    p.x = a;
    p.y = a + 1;
    buf[0] = p.x + p.y;
}

// CHECK-LABEL: struct %Pair
// CHECK: field({{.*}}, Int)
// CHECK: field({{.*}}, Int)

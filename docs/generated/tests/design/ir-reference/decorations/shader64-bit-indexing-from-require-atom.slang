//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#shader64bitindexing
//META: purpose=An explicit [require(spvShader64BitIndexingEXT)] on a callee reaches the entry point as the same shader64BitIndexing decoration the attribute produces.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the third spelling: lowering reads the entry point's inferred
// capability set rather than looking for the attribute, so requiring the
// atom directly must produce the identical decoration. The CHECK is the
// same one the attribute-on-callee sibling uses, which is what makes the
// two spellings observably equivalent.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[require(spvShader64BitIndexingEXT)]
void helper(uint3 tid)
{
    buf[0] = int(tid.x);
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    helper(tid);
}

// CHECK: [shader64BitIndexing]
// CHECK: [nameHint("main")]
// CHECK: func %main

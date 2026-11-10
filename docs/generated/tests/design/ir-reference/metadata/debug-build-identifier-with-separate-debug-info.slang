//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#debug-info-family
//META: purpose=DebugBuildIdentifier records the build identifier of the compilation together with a flags operand when separate debug information is requested.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the module-level build-identifier record. It is only created when
// the compile asks for separate debug information, so that option is passed
// alongside `-g`. The identifier itself is a hash of the source and options
// and therefore matched with a wildcard; the flags operand is pinned because
// it is a stable literal.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -g -separate-debug-info

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: DebugBuildIdentifier("{{[0-9a-f]+}}", {{[0-9]+}} : UInt)

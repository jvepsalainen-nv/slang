//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: purpose=A vector value is typed Vec(elementType, elementCount) in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A vector value is typed Vec(elementType, elementCount) in the IR
// dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<float> buf;
uniform float4 v;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[tid.x] = v.x;
}

// IR-LABEL: func %main
// IR: param %tid {{.*}} Vec(UInt, 3 : Int)
// IR: let {{.*}}%v{{.*}}: Vec(Float, 4 : Int){{.*}}= global_param

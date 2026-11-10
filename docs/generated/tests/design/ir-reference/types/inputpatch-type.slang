//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=An InputPatch<T,N> hull-shader parameter surfaces the InputPatch opcode parameterised by element type and elementCount in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An InputPatch<T,N> hull-shader parameter surfaces the InputPatch
// opcode parameterised by element type and elementCount in the IR
// dump. A hull-shader parameter `InputPatch<VS_OUT, 4>` surfaces the
// `InputPatch` opcode in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage hull -entry hullMain -dump-ir -o -

struct VS_OUT
{
    float3 position : POSITION;
};

struct HS_OUT
{
    float3 position : POSITION;
};

struct HSC_OUT
{
    float EdgeTessFactor[4] : SV_TessFactor;
    float InsideTessFactor[2] : SV_InsideTessFactor;
};

HSC_OUT patchConstant(InputPatch<VS_OUT, 4> patch)
{
    HSC_OUT o;
    o.EdgeTessFactor[0] = 1;
    o.EdgeTessFactor[1] = 1;
    o.EdgeTessFactor[2] = 1;
    o.EdgeTessFactor[3] = 1;
    o.InsideTessFactor[0] = 1;
    o.InsideTessFactor[1] = 1;
    return o;
}

[domain("quad")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(4)]
[patchconstantfunc("patchConstant")]
HS_OUT hullMain(InputPatch<VS_OUT, 4> patch, uint i : SV_OutputControlPointID)
{
    HS_OUT o;
    o.position = patch[i].position;
    return o;
}

// IR-LABEL: func %hullMain
// IR: InputPatch

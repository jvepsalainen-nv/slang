//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=An OutputPatch<T,N> domain-shader parameter surfaces the OutputPatch opcode parameterised by element type and elementCount in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An OutputPatch<T,N> domain-shader parameter surfaces the OutputPatch
// opcode parameterised by element type and elementCount in the IR
// dump. A domain-shader parameter `OutputPatch<HS_OUT, 4>` surfaces
// the `OutputPatch` opcode in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage domain -entry domainMain -dump-ir -o -

struct HS_OUT
{
    float3 position : POSITION;
};

struct HSC_OUT
{
    float EdgeTessFactor[4] : SV_TessFactor;
    float InsideTessFactor[2] : SV_InsideTessFactor;
};

struct DS_OUT
{
    float4 position : SV_Position;
};

[domain("quad")]
DS_OUT domainMain(HSC_OUT hsc, float2 uv : SV_DomainLocation, OutputPatch<HS_OUT, 4> patch)
{
    DS_OUT o;
    o.position = float4(patch[0].position, 1);
    return o;
}

// IR-LABEL: func %domainMain
// IR: OutputPatch

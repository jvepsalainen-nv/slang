//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#sampler-and-buffer-layout-types
//META: purpose=A uniform SamplerComparisonState declaration lowers to a global_param of the nullary IR type SamplerComparisonState.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The comparison sampler is a separate nullary opcode from plain
// SamplerState, so the two are not interchangeable at the IR level. A
// uniform SamplerComparisonState is used in a SampleCmpLevelZero call so
// it survives to the dump; the dump is FileChecked for the named
// global_param typed SamplerComparisonState with no operand list, which
// distinguishes it from the SamplerState opcode covered by the sibling
// sampler test.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage compute -entry main -dump-ir -o -

SamplerComparisonState cmpSampler;
Texture2D<float> depthTex;
RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = depthTex.SampleCmpLevelZero(cmpSampler, float2(0.5, 0.5), 0.5);
}

// IR: let %cmpSampler{{.*}}: SamplerComparisonState{{.*}}= global_param

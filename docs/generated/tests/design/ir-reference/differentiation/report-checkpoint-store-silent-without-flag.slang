//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#checkpointobj-and-reportcheckpointstore
//META: purpose=Nothing is printed from ReportCheckpointStore unless -report-checkpoint-intermediates is passed.
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the gate on the checkpoint report. The shader is the loop shape from
// `report-checkpoint-store-diagnostic.slang`, which does produce a report under
// the flag; here the flag is omitted and the output must carry no checkpoint
// note. The directive's default exit code 0 shows the compile itself succeeded.
// One directive per text-emit target shares a single CHECK prefix, because the
// report walk is back-end independent.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute
//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

uniform float a;
uniform RWStructuredBuffer<float> buf;

[Differentiable]
float loopy(float x)
{
    float acc = x;
    for (int i = 0; i < 4; ++i)
        acc = acc * x + acc;
    return acc;
}

[numthreads(1, 1, 1)]
void main()
{
    var dpx = diffPair(a, 0.0);
    bwd_diff(loopy)(dpx, 1.0);
    buf[0] = dpx.d;
}

// CHECK-NOT: checkpointing context

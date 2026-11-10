//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-fragdepth-and-geometry-primitive-refinements
//META: purpose=A fragment entry point declaring two depth outputs is rejected by the front end with E30705, so the DepthReplacing collapse is unreachable from source.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative: mixing SV_DepthGreaterEqual and SV_DepthLessEqual in one fragment output
// struct is rejected before any SPIR-V legalization runs. CHECK pins E30705.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target spirv-asm -entry main -stage fragment

struct Out
{
    float a : SV_DepthGreaterEqual;
    float b : SV_DepthLessEqual;
};

[shader("fragment")]
Out main()
{
    Out o;
    o.a = 1.0;
    o.b = 1.0;
    return o;
}

// CHECK: E30705

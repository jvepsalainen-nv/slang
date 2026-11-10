//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#variables
//META: purpose=A `static` (non-`const`) global variable emits as a module-scope `static` variable in HLSL; each invocation has its own copy.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `static` (non-const) global emits as a per-invocation module-scope variable
// across every text-emit backend. HLSL uses the `static` keyword; GLSL and WGSL use module-scope
// variables; Metal and CPP wrap it in a KernelContext struct; CUDA folds the value. Each prefix's
// CHECK asserts the variable or its folded value is present in the emitted text.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry computeMain -stage compute

static int gCounter = 0;
RWStructuredBuffer<int> output;
[numthreads(1, 1, 1)]
void computeMain(uint3 id : SV_DispatchThreadID)
{
    gCounter += 1;
    output[0] = gCounter;
}

// HLSL: static
// HLSL: gCounter

// SPV: OpVariable

// GLSL: gCounter{{[_0-9]*}}

// METAL: gCounter{{[_0-9]*}}

// WGSL: var<private> gCounter{{[_0-9]*}}

// CUDA: computeMain

// CPP: gCounter{{[_0-9]*}}

//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#operator-precedence-and-parenthesization
//META: purpose=Arithmetic is left to the language's own precedence: `a + b * c` is emitted verbatim, with no parentheses added around the multiplication, because `+`/`*` is not one of the combinations the emitter deliberately over-parenthesizes.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the deliberate extra-paren rule is scoped to the combinations
// downstream compilers warn about and does not apply to plain arithmetic.
// `a`, `b` and `c` are read from the dispatch id and each is used twice, so
// they survive as named locals and the emitted expression can be matched
// exactly. Each prefix asserts the unparenthesised `a + b * c` form, so a
// regression that started wrapping `b * c` would fail.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry main -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int a = int(tid.x);
    int b = int(tid.y);
    int c = int(tid.z);
    outBuf[0] = a + b * c;
    outBuf[1] = a - b - c;
}

// HLSL: = a_{{[0-9]+}} + b_{{[0-9]+}} * c_{{[0-9]+}};
// GLSL: = a_{{[0-9]+}} + b_{{[0-9]+}} * c_{{[0-9]+}};
// METAL: = a_{{[0-9]+}} + b_{{[0-9]+}} * c_{{[0-9]+}};
// WGSL: = a_{{[0-9]+}} + b_{{[0-9]+}} * c_{{[0-9]+}};
// CUDA: = a_{{[0-9]+}} + b_{{[0-9]+}} * c_{{[0-9]+}};
// CPP: = a_{{[0-9]+}} + b_{{[0-9]+}} * c_{{[0-9]+}};

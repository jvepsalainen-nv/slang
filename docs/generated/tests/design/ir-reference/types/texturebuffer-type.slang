//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A TextureBuffer<T> uniform lowers to a global_param of IR type TextureBuffer(<T>) carrying only the element type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// TextureBuffer is its own opcode in the parameter-group family and,
// unlike the structured-buffer family, takes no data-layout operand — the
// element type is its only operand. A `TextureBuffer<P> tb` global is
// read in the kernel; the dump is FileChecked for the named global_param
// typed `TextureBuffer(%P)` with the closing parenthesis right after the
// struct, which pins the single-operand shape against the two-operand
// ConstantBuffer covered by the sibling constant-buffer test.

//TEST:SIMPLE(filecheck=IR):-target hlsl -stage compute -entry main -dump-ir -o -

struct P { float4 a; }

TextureBuffer<P> tb;
RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = tb.a.x;
}

// IR: let %tb{{.*}}: TextureBuffer(%P){{.*}}= global_param

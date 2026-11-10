//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=The format attribute's argument is declared as a String, so a bare identifier such as [format(rgba32f)] is rejected with E33071 rather than being read as a format name.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the argument-form half of the format attribute. The name of an
// image format looks like an identifier, so the natural mistake is to write it
// unquoted; because the attribute's parameter is a `String`, that spelling is
// a type error at the argument rather than an unknown-format error. CHECK
// pins E33071 at the argument token, which is what distinguishes "the argument
// must be a string literal" from "this format name is not recognised". The
// sibling test format-attribute-emits-spirv-image-format.slang shows the
// quoted spelling being accepted and reaching the emitted image type.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target spirv-asm -stage compute -entry computeMain

[format(rgba32f)]
/*CHECK:
        ^^^^^^^ E33071
*/
RWTexture2D<float4> tex;

[numthreads(1, 1, 1)]
void computeMain()
{
    tex[int2(0, 0)] = float4(1, 0, 0, 1);
}

//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=ByteAddressBuffer and RWByteAddressBuffer uniforms lower to global_params of the same-spelled IR types (no element-type operand).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// ByteAddressBuffer and RWByteAddressBuffer uniforms lower to
// global_params of the same-spelled IR types (no element-type
// operand). Both uniforms surface as bare-named IR types on their
// respective `global_param` instructions.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform ByteAddressBuffer src;
uniform RWByteAddressBuffer dst;

[numthreads(1, 1, 1)]
void main()
{
    dst.Store(0, src.Load(0));
}

// IR: let {{.*}}%src{{.*}}: ByteAddressBuffer{{.*}}= global_param
// IR: let {{.*}}%dst{{.*}}: RWByteAddressBuffer{{.*}}= global_param

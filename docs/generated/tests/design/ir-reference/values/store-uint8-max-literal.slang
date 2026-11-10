//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=Boundary: documented `uint8_t` MAX (255) and lower-edge (0) survive lowering as `255 : UInt8` and `0 : UInt8` on the `store` operands.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Both edges of the unsigned-8 range on the literal-payload axis.
// The IR dump shows each integer literal as `<N> : UInt8` directly
// on the store opcode that writes the value into the buffer.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<uint8_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint8_t(0);
    buf[1] = uint8_t(255);
}

// IR-LABEL: func %main
// IR: store(%{{.*}}, 0 : UInt8)
// IR: store(%{{.*}}, 255 : UInt8)

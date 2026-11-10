//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A SubpassInput<T> uniform declared in a fragment entry point surfaces the SubpassInputType opcode parameterised by its element type in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A SubpassInput<T> uniform declared in a fragment entry point
// surfaces the SubpassInputType opcode parameterised by its element
// type in the IR dump. A fragment-shader global `SubpassInput<float4>`
// surfaces the `SubpassInputType` opcode on a `global_param` in the IR
// dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -stage fragment -entry main -dump-ir -o -

[[vk::input_attachment_index(0)]] SubpassInput<float4> inputColor;

float4 main() : SV_Target
{
    return inputColor.SubpassLoad();
}

// IR: let {{.*}}%inputColor{{.*}}: SubpassInputType{{.*}}= global_param

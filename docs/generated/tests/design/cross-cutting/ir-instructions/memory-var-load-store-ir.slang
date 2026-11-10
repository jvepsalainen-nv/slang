//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#memory-instructions
//META: purpose=A local struct variable lowers to `var` and its field reads/writes lower to `store` / `load` / `get_field_addr` IR opcodes.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's memory-instruction rows in one shot. A locally
// declared struct `Foo` is allocated via `var` ("Local variable
// allocation; result is Ptr<T>"); a field assignment lowers to
// `get_field_addr` plus `store`; and the read-back uses `load`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Foo { int x; int y; }

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Foo f;
    f.x = a;
    f.y = a + 1;
    buf[0] = f.x + f.y;
}

// IR-LABEL: func %main
// IR: var
// IR: get_field_addr(%{{.*}}, %{{.*}})
// IR: store(%{{.*}}, %{{.*}})
// IR: load(%{{.*}})

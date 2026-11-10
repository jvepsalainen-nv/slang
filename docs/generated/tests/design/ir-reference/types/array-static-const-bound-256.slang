//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=Stress: a large `static const`-bounded array surfaces the full extent as Array(Float, 256 : Int).
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a large `static const`-bounded array surfaces the full extent as
// Array(Float, 256 : Int). A `static const int N = 256;` used as the
// extent is folded to the integer literal `256 : Int` on the `Array`
// opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

static const int N = 256;
struct Big { float data[N]; }
uniform Big b;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = b.data[N - 1];
}

// IR-LABEL: struct %Big
// IR: field(%{{.*}}, Array(Float, 256 : Int))

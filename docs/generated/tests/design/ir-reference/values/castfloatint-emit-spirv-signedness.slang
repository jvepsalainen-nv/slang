//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: doc_section_digest=e98041c33a94ddbbb2f967b2078765fb561c2b5e826bdd9ca046a44763e172fe
//META: purpose=`castFloatToInt` lowers to `OpConvertFToS`/`OpConvertFToU` keyed by the target integer's signedness, and `castIntToFloat` lowers to `OpConvertSToF`/`OpConvertUToF` keyed by the source integer's signedness.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc lists `castFloatToInt` ("Float-to-int conversion (truncation)")
// and `castIntToFloat` ("Int-to-float conversion") as single opcodes. Each
// splits in SPIR-V on the integer side's signedness: float->signed emits
// `OpConvertFToS`, float->unsigned `OpConvertFToU`, signed->float
// `OpConvertSToF`, unsigned->float `OpConvertUToF`. All four cells are
// distinct; CHECK pins each. Operands are uniforms so the casts survive.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

uniform float f;
uniform int si;
uniform uint ui;
uniform RWStructuredBuffer<int> ibuf;
uniform RWStructuredBuffer<uint> ubuf;
uniform RWStructuredBuffer<float> fbuf;

[numthreads(1, 1, 1)]
void main()
{
    ibuf[0] = int(f);
    ubuf[0] = uint(f);
    fbuf[0] = float(si);
    fbuf[1] = float(ui);
}

// SPV-DAG: OpConvertFToS %int %{{[0-9]+}}
// SPV-DAG: OpConvertFToU %uint %{{[0-9]+}}
// SPV-DAG: OpConvertSToF %float %{{[0-9]+}}
// SPV-DAG: OpConvertUToF %float %{{[0-9]+}}

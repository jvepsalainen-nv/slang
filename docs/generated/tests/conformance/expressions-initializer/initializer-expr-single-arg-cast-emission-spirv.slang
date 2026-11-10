//META: generated=true
//META: doc_ref=docs/language-reference/expressions-initializer.md#initializer-expressions
//META: purpose=A single-argument initializer expression int(f) emits as an int() cast in HLSL, matching the C-style cast form.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the single-argument initializer expression `int(f)` lowers to the
// float-to-signed conversion `OpConvertFToS` in SPIR-V — the same op the
// C-style cast produces. Both helpers feed a buffer to defeat DCE; CHECK
// asserts two OpConvertFToS instructions appear, one per cast form.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -stage compute -entry main

float passFloat(float f) { return f; }

int castViaInitExpr(float f)
{
    return int(f);
}

int castViaCStyle(float f)
{
    return (int)f;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main(RWStructuredBuffer<int> buf)
{
    buf[0] = castViaInitExpr(passFloat(buf[1]));
    buf[2] = castViaCStyle(passFloat(buf[3]));
}

// CHECK-DAG: %{{[0-9]+}} = OpConvertFToS %int %{{[A-Za-z0-9_]+}}
// CHECK-DAG: %{{[0-9]+}} = OpConvertFToS %int %{{[A-Za-z0-9_]+}}

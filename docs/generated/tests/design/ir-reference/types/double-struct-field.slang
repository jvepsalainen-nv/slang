//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#struct-and-class-containers
//META: purpose=Expansion: a struct field of Double lowers to a field(...) row carrying Double.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a struct field of Double lowers to a field(...) row carrying Double.
// A struct holding `double` fields produces `field(%key, Double)`
// rows.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Wide { double x; double y; }

uniform Wide w;
uniform RWStructuredBuffer<double> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = w.x + w.y;
}

// IR-LABEL: struct %Wide
// IR: field(%{{.*}}, Double)

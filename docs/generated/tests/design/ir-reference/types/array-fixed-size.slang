//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#arrays
//META: purpose=A fixed-size array field appears as Array(elementType, elementCount) in the IR dump.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A fixed-size array field appears as Array(elementType, elementCount)
// in the IR dump. A struct-field of type `float[8]` and a local
// `int[3]` together surface `Array(Float, 8 : Int)` and `Array(Int, 3
// : Int)` in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Bag { float data[8]; }

uniform float a;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    Bag b;
    b.data[0] = a;
    b.data[1] = a + 1;
    b.data[7] = a + 7;

    int xs[3];
    xs[0] = int(a);
    xs[1] = int(a) + 1;
    xs[2] = int(a) + 2;

    buf[0] = b.data[1] + float(xs[2]);
}

// IR-LABEL: struct %Bag
// IR: field(%{{.*}}, Array(Float, 8 : Int))
// IR-LABEL: func %main
// IR: let {{.*}}%xs{{.*}}: Ptr(Array(Int, 3 : Int)){{.*}}= var

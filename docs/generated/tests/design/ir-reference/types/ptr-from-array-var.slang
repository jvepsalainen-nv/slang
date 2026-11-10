//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#ptr-and-the-access-qualifier--address-space-operands
//META: purpose=Boundary: a local var of fixed-array type produces a value of IR type Ptr(Array(<T>, <N>)).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// a local var of fixed-array type produces a value of IR type
// Ptr(Array(<T>, <N>)). A local fixed-size array variable is allocated
// via `var` and its result is typed `Ptr(Array(Int, 3 : Int))` —
// composition between `Ptr` and `Array`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int xs[3];
    xs[0] = a;
    xs[1] = a + 1;
    xs[2] = a + 2;
    buf[0] = xs[0] + xs[1] + xs[2];
}

// IR-LABEL: func %main
// IR: let {{.*}}%xs{{.*}}: Ptr(Array(Int, 3 : Int)){{.*}}= var

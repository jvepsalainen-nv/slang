//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#ptr-and-the-access-qualifier--address-space-operands
//META: purpose=A local var of struct type produces a value whose IR type is Ptr<T>.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A local var of struct type produces a value whose IR type is Ptr<T>.
// A local struct variable accessed by field address keeps its `var`
// form and the result is typed `Ptr(<StructName>)` in the dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Foo { int x; int y; }

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    Foo f;
    f.x = a;
    f.y = a + 1;
    buf[0] = f.x + f.y;
}

// IR-LABEL: func %main
// IR: let {{.*}}%f{{.*}}: Ptr(%Foo){{.*}}= var

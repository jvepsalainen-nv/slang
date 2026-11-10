//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#getelementptr-vs-getelement
//META: purpose=Array indexing in lvalue position lowers to `getElementPtr`; indexing into a struct-field array value lowers to `getElement`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the distinction between `GetElementPtr` and `GetElement`, which separates the address-returning (`getElementPtr`) and
// value-returning (`getElement`) forms. A local array indexed by a
// dynamic index produces both opcodes: the writes use `getElementPtr`
// + `store`, while indexing the struct-field array value uses
// `getElement` directly.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct S
{
    int arr[4];
}

uniform S s;
uniform int a;
uniform int idx;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int local[4];
    local[0] = a;
    local[1] = a + 1;
    local[2] = a + 2;
    local[3] = a + 3;
    buf[0] = local[idx];
    buf[1] = s.arr[idx];
}

// IR-LABEL: func %main
// IR: getElementPtr(%local, 0 : Int)
// IR: getElementPtr(%local, %idx)
// IR: getElement(%{{.*}}, %idx)

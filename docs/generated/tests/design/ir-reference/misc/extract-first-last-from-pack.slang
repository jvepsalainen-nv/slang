//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#pack-and-expansion
//META: purpose=`__first(pack)` and `__last(pack)` lower to `ExtractFirstFromPack` / `ExtractLastFromPack`, each taking the pack plus a `NonEmptyPackWitness` built for it.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two-operand `pack, witness` shape the doc gives for the pack
// query opcodes, and that the witness operand is a separately-emitted
// `NonEmptyPackWitness` over the same pack rather than a constant. The `where
// nonempty(D)` constraint is what makes the query well-formed; the CHECKs read
// the generic bodies in the IR dump and pin the witness line immediately
// feeding each extract.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<int> outputBuffer;

int firstValue<let each D : int>() where nonempty(D)
{
    return __first(D);
}

int lastValue<let each D : int>() where nonempty(D)
{
    return __last(D);
}

[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = firstValue<10, 20, 30>();
    outputBuffer[1] = lastValue<10, 20, 30>();
}

// IR-DAG: = NonEmptyPackWitness(%{{[A-Za-z0-9_]+}})
// IR-DAG: = ExtractFirstFromPack(%{{[A-Za-z0-9_]+}}, %{{[A-Za-z0-9_]+}})
// IR-DAG: = ExtractLastFromPack(%{{[A-Za-z0-9_]+}}, %{{[A-Za-z0-9_]+}})

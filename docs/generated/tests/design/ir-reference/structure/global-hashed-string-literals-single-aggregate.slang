//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#global-state
//META: purpose=Two hashed string literals in one module share a single global_hashed_string_literals aggregate rather than getting one container each.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Exercises the cardinality claim on the hashed-string-literal pool: a module
// holds at most one of these aggregates. Two distinct literals are hashed in
// the same entry point; CHECK requires both to appear in the operand list of
// one `global_hashed_string_literals` inst, which would be impossible if each
// literal had produced its own container.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int seed;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(getStringHash("alpha")) + int(getStringHash("beta")) + seed;
}

// CHECK: global_hashed_string_literals("alpha", "beta")

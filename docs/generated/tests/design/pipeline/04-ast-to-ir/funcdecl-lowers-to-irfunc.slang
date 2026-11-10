//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A FuncDecl lowers to an IRFunc whose body contains one or more IRBlocks; a callsite lowers to a `call` instruction.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A user-defined helper function appears in the IR as a `func`
// instruction with `block` children. The call to it from `main`
// appears as a `call %helper(...)`. This is the doc's "FuncDecl → IRFunc
// containing one or more IRBlocks" entry of the mapping table.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

int helper(int v) { return v + 1; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = helper(a);
}

// CHECK-LABEL: func %helper
// CHECK: block %{{.*}}
// CHECK-LABEL: func %main
// CHECK: call %helper

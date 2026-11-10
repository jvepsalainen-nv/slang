//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#linkage-and-lifetime
//META: purpose=A user-declared uniform global parameter carries an export decoration with the variable-linkage mangled name (prefix _SV).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `export` is attached to global parameters, not only to
// functions, and that the mangled name it carries is namespaced by symbol
// kind. The CHECK pins the `_SV` variable prefix together with the
// parameter's `nameHint` and the `let %buf` declaration line, so the
// decoration is tied to the global it names.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [nameHint("buf")]
// CHECK: [export("_SV{{.*}}buf{{.*}}")]
// CHECK: let  %buf

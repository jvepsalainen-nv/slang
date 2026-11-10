//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#defaultconstruct
//META: purpose=The `defaultConstruct` opcode does survive for the types lowering cannot decompose: an interface-typed value and an unspecialized generic type parameter both default-initialize to the nullary opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positive half of the `defaultConstruct` story. Its
// sibling test defaultconstruct-vector-splat.slang shows the common
// case, where lowering decomposes the result type and the opcode never
// appears; this one picks two types that have no decomposition. An
// interface-typed local has no fields to fill in, and inside a generic
// the type parameter `T` is still abstract, so both `{}` initializers
// reach the nullary fallback. CHECK asserts one `defaultConstruct`
// whose result type is the user interface `%IThing`, and a second one
// inside `func %makeDefault` typed by the generic parameter, so each
// observation names the undecomposable type it came from. The surviving
// `defaultConstruct` has no emitter on any target (code emit aborts with
// an internal error), so the test stops after IR lowering with
// `-skip-codegen`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -skip-codegen -dump-ir -o - -stage compute -entry main

interface IThing { int get(); }
struct Impl : IThing { int get() { return 7; } }

uniform RWStructuredBuffer<int> buf;

[noinline]
int use(IThing t) { return t.get(); }

[noinline]
T makeDefault<T>()
{
    T t = {};
    return t;
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    // Impl must be used so the linkage holds a conformance for IThing;
    // otherwise codegen rejects the program with E50100.
    Impl im;
    IThing t = {};
    buf[tid.x] = use(im) + use(t) + makeDefault<int>();
}

// IR-LABEL: func %makeDefault
// IR: : %T{{[A-Za-z0-9_]*}}	= defaultConstruct
// IR-LABEL: func %main
// IR: : %IThing	= defaultConstruct

//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30076 (opaque-type-not-supported-for-mutable-static) - opaque type is not supported for mutable static storage
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30076
//META: catalog_name=opaque-type-not-supported-for-mutable-static
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Constant buffers have a target-dependent legalized representation that resource-global
// replacement does not support, so the front end rejects this declaration.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
struct MaterialState
{
    float value;
}

static ConstantBuffer<MaterialState> gBuffer;
void main() { }

//CHECK: E30076

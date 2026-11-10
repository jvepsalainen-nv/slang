//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#torch
//META: purpose=The PyTorch binding target is special-cased to the Torch emitter, which emits the PyTorch C++ glue (a `PYBIND11_MODULE` with an `m.def` per `[TorchEntryPoint]`) on top of the Torch prelude.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `-target torch` selects the Torch emitter rather than the
// plain C++ emitter it derives from. CHECK asserts the Torch-only prelude
// content (`torch/extension.h`) and the pybind11 module registration that
// only the Torch emitter writes; a plain C++ emit of the same source would
// have neither. The emitted function itself is still C++, so the exported
// symbol is asserted too.

//TEST:SIMPLE(filecheck=TORCH):-target torch

[TorchEntryPoint]
float scaleByTwo(float x)
{
    return x * 2.0f;
}

// TORCH-DAG: torch/extension.h
// TORCH-DAG: SLANG_PRELUDE_EXPORT
// TORCH-DAG: float scaleByTwo(float
// TORCH-DAG: PYBIND11_MODULE(TORCH_EXTENSION_NAME, m)
// TORCH-DAG: m.def("scaleByTwo"

---
generated: true
model: claude-opus-4-8
generated_at: 2026-06-11T11:23:45+00:00
source_commit: 273e29cb6cac600f70da7245a506bae6689e0e23
watched_paths_digest: 3fb46f1e2e50bbf9f20cca08f8ad621c15159665714bf49de17ebea46ccc0d73
source_doc: docs/language-reference/expressions-identifier.md
source_doc_digest: 0c4ea61f719b8e3f883504cf6aafc03da814a45151d6ce280c5b8735175453f6
warning: "Auto-generated. May drift from source. Do not edit by hand."
---

# Tests for conformance/expressions-identifier

## Intent

Tests verify identifier-expression semantics claimed in the **language reference** at
[`docs/language-reference/expressions-identifier.md`](../../../../language-reference/expressions-identifier.md).
The doc has two named sections — **Overloading** and **Implicit Lookup** — plus a preamble
establishing basic lookup and l-value rules. Coverage strategy: one functional test per basic
claim, one negative/diagnostic test for the "is rejected" overload-ambiguity claim (with
pinned `E39999`), emission tests for the cbuffer/tbuffer implicit-lookup claim and for
the overload-disambiguation claim, and extension-method as a secondary dimension for implicit-`this`.

## Claims

### Preamble (Identifier Expressions)

- C1: An identifier expression looks up the name in the current environment and yields the value of the matching declaration.
- C2: An identifier expression is an l-value when the declaration it refers to is mutable.

### Overloading

- C3: An identifier expression can be overloaded — it may refer to one or more candidate declarations with the same name.
- C4: When the correct candidate can be disambiguated from context, that candidate is used as the result of the name expression.
- C5: When an overloaded name cannot be disambiguated, its use is an error at the use site.

### Implicit Lookup

- C6: In the body of a method, a bare identifier may resolve to `this.someName` via the implicit `this` parameter of the method.
- C7: When a global-scope `cbuffer` or `tbuffer` declaration is used, a bare identifier may refer to a field declared inside it.

## Functional coverage

| Claim                                                                                                                             | Intent               | Anchor                                                                                                     | Tests                                                                                                                                                                                                                                                                        |
| --------------------------------------------------------------------------------------------------------------------------------- | -------------------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| C1: An identifier expression looks up the name in the environment and yields the value of the matching declaration.               | functional           | [#identifier-expressions](../../../../language-reference/expressions-identifier.md#identifier-expressions) | [`identifier-basic-lookup-functional.slang`](identifier-basic-lookup-functional.slang)                                                                                                                                                                                       |
| C2: An identifier expression is an l-value when the declaration it refers to is mutable, allowing assignment and `inout` passing. | functional           | [#identifier-expressions](../../../../language-reference/expressions-identifier.md#identifier-expressions) | [`identifier-lvalue-mutable-functional.slang`](identifier-lvalue-mutable-functional.slang)                                                                                                                                                                                   |
| C3+C4: An overloaded identifier resolves to the correct candidate when the call context disambiguates by argument type.           | functional, boundary, expansion | [#overloading](../../../../language-reference/expressions-identifier.md#overloading)                       | [`overload-disambiguation-functional.slang`](overload-disambiguation-functional.slang), [`overload-return-type-context-functional.slang`](overload-return-type-context-functional.slang), [`overload-disambiguation-emission.slang`](overload-disambiguation-emission.slang), [`overload-disambiguation-emission-crosstarget.slang`](overload-disambiguation-emission-crosstarget.slang) |
| C5: When an overloaded identifier cannot be disambiguated, an ambiguous-call error (E39999) is emitted at the use site.           | negative             | [#overloading](../../../../language-reference/expressions-identifier.md#overloading)                       | [`overload-ambiguous-error.slang`](overload-ambiguous-error.slang)                                                                                                                                                                                                           |
| C6: In a method body, a bare identifier resolves to `this.fieldName` via the implicit `this` parameter.                           | functional           | [#implicit-lookup](../../../../language-reference/expressions-identifier.md#implicit-lookup)               | [`implicit-this-lookup-functional.slang`](implicit-this-lookup-functional.slang), [`implicit-this-lookup-extension-functional.slang`](implicit-this-lookup-extension-functional.slang)                                                                                       |
| C7: A bare identifier resolves to a field declared inside a global-scope `cbuffer`.                                               | functional, expansion | [#implicit-lookup](../../../../language-reference/expressions-identifier.md#implicit-lookup)               | [`implicit-cbuffer-lookup-emission.slang`](implicit-cbuffer-lookup-emission.slang), [`implicit-cbuffer-lookup-emission-crosstarget.slang`](implicit-cbuffer-lookup-emission-crosstarget.slang)                                                                               |
| C7: A bare identifier resolves to a field declared inside a global-scope `tbuffer`.                                               | functional, expansion | [#implicit-lookup](../../../../language-reference/expressions-identifier.md#implicit-lookup)               | [`implicit-tbuffer-lookup-emission.slang`](implicit-tbuffer-lookup-emission.slang), [`implicit-tbuffer-lookup-emission-crosstarget.slang`](implicit-tbuffer-lookup-emission-crosstarget.slang)                                                                               |

## Untested claims

| Claim                                                                                                                                                                  | Reason                | Anchor                                                                                       | Why untested                                                                                                                                                                                                                                                       |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A bare identifier resolves to a field declared inside a global-scope tbuffer, via implicit tbuffer lookup.                                                              | unsupported-on-target | [#implicit-lookup](../../../../language-reference/expressions-identifier.md#implicit-lookup)  | spirv-asm only: emitting a `tbuffer` (TextureBuffer) to spirv-asm aborts with E99997 `unhandled global inst in spirv-emit: TextureBuffer(...)` (exit 255). Already filed as compiler bug `declarations-tbuffer-spirv-cuda-cpp-crash.yaml`; no passing test written for this target. Covered on glsl/metal/wgsl.                          |
| Overload disambiguation is reflected in emitted HLSL as distinct mangled function names for each resolved overload.                                                     | unsupported-on-target | [#overloading](../../../../language-reference/expressions-identifier.md#overloading)          | spirv-asm only: SPIR-V inlines and constant-folds both trivial `probe` calls (result reduces to `%30 = OpIAdd %int %int_1 %int_2`); no distinct function definitions survive in the SPIR-V to observe the distinct-mangled-name claim. The claim stays observable on glsl/metal/wgsl. |

## Doc gaps observed

| Anchor                                                                                       | Kind            | Gap                                                                                                                                                                                                                                                                                                | Suggested addition                                                                                                                                                                                                                |
| -------------------------------------------------------------------------------------------- | --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [#implicit-lookup](../../../../language-reference/expressions-identifier.md#implicit-lookup)  | missing-example | The doc states a bare identifier resolves to a `cbuffer`/`tbuffer` field but names only the generic behavior; it does not enumerate the per-target emitted form (GLSL/WGSL `Group.field`, Metal `kernelContext->Group->field`, SPIR-V `OpMemberName`), nor that `tbuffer`→SPIR-V is unimplemented.   | Add a per-target emission note showing how an implicitly-looked-up parameter-group field is qualified on each back-end, and flag that `tbuffer` emission to SPIR-V/CUDA/CPP is currently unsupported.                              |
| [#overloading](../../../../language-reference/expressions-identifier.md#overloading)          | missing-example | The doc says overload disambiguation selects a candidate but does not state that the selection is observable as distinct mangled function definitions in emitted text, nor that trivial overloads may be inlined away (e.g. SPIR-V folds them to a constant), erasing the distinct-name signal.       | Add a note that disambiguated overloads emit as distinct mangled functions on text targets, with the caveat that inlining/constant-folding may eliminate trivial callees on some back-ends (SPIR-V).                              |

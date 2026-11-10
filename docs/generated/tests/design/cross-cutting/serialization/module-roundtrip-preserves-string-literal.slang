//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/serialization.md#ir-flat-module-read-path
//META: purpose=The flat-module encoding keeps string payloads in side tables of lengths plus one concatenated character stream, and a string literal inside a module function reappears verbatim after a write/read round-trip.
//META: intent=functional
//META: pipeline_stage=link
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a string payload stored away from its instruction - the
// on-disk form holds per-string lengths and one concatenated character
// stream, not inline text - is re-attached to the right instruction on
// load. The module's only string payload is a distinctive printf format
// string; after writing the container and reading it back with
// -dump-module, seeing that exact literal in the dumped IR is what
// proves the reader walked the length table and sliced the character
// stream at the right offset.

//TEST:COMPILE: docs/generated/tests/design/cross-cutting/serialization/module-roundtrip-preserves-string-literal.slang -o docs/generated/tests/design/cross-cutting/serialization/module-roundtrip-preserves-string-literal.slang-module
//TEST:SIMPLE(filecheck=CHECK): -dump-module docs/generated/tests/design/cross-cutting/serialization/module-roundtrip-preserves-string-literal.slang-module

module module_roundtrip_preserves_string_literal;

public void announce()
{
    printf("serialized-string-payload-7f3a\n");
}

// CHECK-DAG: [nameHint("announce")]
// CHECK-DAG: serialized-string-payload-7f3a

//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=A lexer/parser-range code (E20001) is rendered for an unterminated struct body.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin the parse-stage diagnostic id for an unterminated struct.
// The compiler emits E20001 "unexpected end of file, expected '}'".
// We use a SIMPLE FileCheck so we can match the code on a
// non-source line (EOF position).

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl
struct S {

// CHECK: E20001
// CHECK: unexpected end of file, expected '}'

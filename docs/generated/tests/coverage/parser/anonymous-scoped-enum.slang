//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=Verifies an `enum class` with no name (anonymous scoped enum) is rejected with E32001.
//META: intent=characterization
//META: covers=source/slang/slang-parser.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: the enum-declaration parser permits an anonymous
// unscoped enum but a scoped enum (`enum class`) must be named, since its
// members are only reachable through the type name. An anonymous `enum class`
// drives the anonymous-scoped-enum branch. CHECK pins E32001.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

enum class { A, B }
//CHECK: E32001
//CHECK: 'class' keyword specifies a scoped enumeration

[numthreads(1, 1, 1)]
void main() {}

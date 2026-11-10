//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#body
//META: purpose=A function declaration without a body (forward declaration) is allowed and is terminated with a semicolon.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a body-less function declaration (forward declaration, terminated with `;`) compiles.
// `func getCount() -> int;` declares without a body; the subsequent definition satisfies it.
// Emitting `void main` (asserted below) confirms the program compiled successfully.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

func getCount() -> int;

int getCount() { return 42; }

[numthreads(1, 1, 1)]
void main() {}

// CHECK: void main

//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#decorations
//META: purpose=A user-named declaration carries a `nameHint` decoration in the IR carrying its identifier name.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `NameHintDecoration`/`IRNameHintDecoration` row
// ("Carries an identifier name for debug / link output"). The
// user-named helper `myHelper` carries a `[nameHint("myHelper")]`
// decoration in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

int myHelper(int x) { return x + 1; }

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = myHelper(a);
}

// IR: [nameHint("myHelper")]

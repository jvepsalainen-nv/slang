//META: generated=true
//META: purpose=An unknown name inside a `spirv_asm` `builtin(...)` operand is reported as an unknown SPIR-V identifier (E29107).
//META: intent=characterization
//META: covers=source/slang/slang-check-expr.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes the BuiltinVar operand branch of visitSPIRVAsmExpr, which is
// separate from the ordinary NamedValue lookup: a `builtin(Name:Type)` operand
// is resolved only against the `BuiltIn` operand kind's enumerator table. The
// test passes a name that is not a SPIR-V built-in variable, so that dedicated
// lookup fails and reports E29107 against the name token.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target spirv -entry test -stage compute

[numthreads(1, 1, 1)]
void test()
{
    let v = spirv_asm { result:$$uint = OpLoad $$uint builtin(NotABuiltin:uint); };
//CHECK:                                                      ^^^^^^^^^^^ E29107
//CHECK:                                                      ^^^^^^^^^^^ unknown SPIR-V identifier NotABuiltin, it's not a known enumerator or opcode
}

//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E36101 (conflicting-capability-due-to-statement) - conflicting capability requirement
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=36101
//META: catalog_name=conflicting-capability-due-to-statement
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `__target_switch` case that conflicts with the enclosing
// function's [require(...)] declaration triggers E36101.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive): -target spirv -emit-spirv-directly -entry main -stage compute -skip-spirv-validation

[require(glsl, _sm_4_0)]
public void use1()
{
    __target_switch
    {
    case glsl:
        return;
    }
}

void main()
{
    use1();
}

//CHECK: E36101

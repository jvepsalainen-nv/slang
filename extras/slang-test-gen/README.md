# Slang Test Generator

A general-purpose test generator for creating Slang test files from YAML configuration and shader templates.

## Features

- **Template-based**: Use shader templates with variable substitution
- **Multiple variants**: Generate multiple test variants from a single configuration
- **Flexible test directives**: Support for all Slang test types (SIMPLE, COMPARE_COMPUTE, INTERPRET, etc.)
- **FileCheck patterns**: Define expected output patterns for verification
- **Test inputs**: Configure buffers, textures, samplers, and other test inputs
- **Disabled test tracking**: Link disabled tests to GitHub issues
- **YAML schema**: Well-defined schema for validation and documentation

## Quick Start

### 1. Create a Shader Template

Create a shader file with template variables (optional):

```slang
// shader.slang
[numthreads({{BUFFER_SIZE}}, 1, 1)]
void computeMain(uint3 tid: SV_DispatchThreadID)
{
    outputBuffer[tid.x] = {{DEFAULT_VALUE}};
}
```

### 2. Create a YAML Configuration

```yaml
# config.yaml
test_config:
  name: my-test
  shader_template: "./shader.slang"
  output_pattern: "{variant_name}.slang"
  
  global_inputs:
    - name: outputBuffer
      type: ubuffer
      parameters: "data=[0], stride=4"
      declaration: "RWStructuredBuffer<int> outputBuffer;"
  
  global_template_vars:
    BUFFER_SIZE: 4
    DEFAULT_VALUE: 42

variants:
  cpu-test:
    description: "CPU compute test"
    directives:
      - type: COMPARE_COMPUTE
        flags: "-cpu -output-using-type"
        filecheck: RESULT
    
    filecheck_patterns:
      RESULT:
        - "42"
```

### 3. Generate Tests

```bash
python slang-test-gen.py config.yaml --output-dir ./output
```

This will generate `output/cpu-test.slang` with the complete test file.

## Usage

### Basic Usage

```bash
# Generate tests from configuration
python slang-test-gen.py <config.yaml> [options]

# Validate configuration without generating
python slang-test-gen.py <config.yaml> --validate-only

# Specify output directory
python slang-test-gen.py <config.yaml> --output-dir ./tests

# Override shader template from command line
python slang-test-gen.py <config.yaml> --shader ./my-shader.slang
```

### Command-Line Options

- `config.yaml`: Path to YAML configuration file (required)
- `--output-dir DIR`: Output directory for generated tests (default: current directory)
- `--shader FILE`: Override shader template file (optional)
- `--validate-only`: Only validate configuration without generating tests

## Configuration Format

### Top-Level Structure

```yaml
test_config:
  # Required fields
  name: string                    # Test suite name (lowercase, hyphens/underscores)
  shader_template: string         # Path to shader file or inline code
  
  # Optional fields
  description: string             # Description of test suite
  output_pattern: string          # Output filename pattern (default: "{name}-{variant_name}.slang")
  generation_comment: string      # Comment at top of generated files
  global_inputs: [...]            # Inputs shared across all variants
  global_template_vars: {...}     # Template variables for all variants

variants:
  variant-name:                   # Each variant generates one test file
    # Variant configuration...
```

### Test Inputs

Test inputs define resources used by the test:

```yaml
inputs:
  - name: outputBuffer
    type: ubuffer                 # Input type (ubuffer, Texture2D, Sampler, etc.)
    parameters: "data=[0], stride=4"
    declaration: "RWStructuredBuffer<int> outputBuffer;"  # Optional Slang code

  - name: myTexture
    type: Texture2D
    parameters: "size=4, content=zero"
    declaration: "Texture2D<float4> myTexture;"
  
  - name: samplerState
    type: Sampler
    parameters: "filteringMode=point"
    declaration: "SamplerState samplerState;"
```

### Test Directives

Test directives define how the test should run:

```yaml
directives:
  # SIMPLE test
  - type: SIMPLE
    flags: "-entry main -stage compute -target spirv"
    filecheck: CHECK
    enabled: true

  # COMPARE_COMPUTE test
  - type: COMPARE_COMPUTE
    flags: "-cpu -output-using-type"
    filecheck: RESULT
    enabled: true

  # Disabled test with GitHub issue
  - type: SIMPLE
    flags: "-target wgsl"
    filecheck: CHECK
    enabled: false
    disable_reason: 8786          # GitHub issue number

  # Disabled test with custom reason
  - type: SIMPLE
    flags: "-target metal"
    enabled: false
    disable_reason: "Not yet implemented"
```

Supported test types:
- `SIMPLE`: Basic compilation test
- `COMPARE_COMPUTE`: Compute shader with output comparison
- `INTERPRET`: Interpreter test
- `CROSS_COMPILE`: Cross-compilation test
- `COMPILE_FAIL`: Expected compilation failure
- `CUSTOM`: Custom test directive

### Template Variables

Template variables allow customizing shader code:

```yaml
# Global variables (available to all variants)
global_template_vars:
  BUFFER_SIZE: 4
  ENTRY_POINT: main

# Variant-specific variables (override globals)
variants:
  my-variant:
    template_vars:
      BUFFER_SIZE: 8  # Overrides global
      CUSTOM_VALUE: 42
```

In shader templates, use `{{VARIABLE_NAME}}`:

```slang
[numthreads({{BUFFER_SIZE}}, 1, 1)]
void {{ENTRY_POINT}}()
{
    int value = {{CUSTOM_VALUE}};
}
```

### FileCheck Patterns

Define expected output patterns for verification:

```yaml
filecheck_patterns:
  POSITIVE:
    - "POSITIVE-NOT: {{(error|warning).*}}:"
    - "result code = 0"
    - "POSITIVE-LABEL: main"
  
  NEGATIVE:
    - "error [[:digit:]]+"
  
  RESULT:
    - "12345"
```

### Output Filename Pattern

Control generated filenames using placeholders:

```yaml
output_pattern: "{name}-{variant_name}.slang"
# Generates: my-test-cpu-variant.slang

output_pattern: "{variant_name}.slang"
# Generates: cpu-variant.slang

output_pattern: "gen-{name}-{variant_name}.slang"
# Generates: gen-my-test-cpu-variant.slang
```

Available placeholders:
- `{name}`: Test suite name
- `{variant_name}`: Variant name

## Examples

See the `examples/` directory for complete examples:

1. **simple-compute.yaml**: Basic compute shader test
2. **texture-test.yaml**: Texture capability tests across backends

### Example: Simple Compute Test

```yaml
test_config:
  name: simple-compute
  shader_template: "./shader.slang"
  output_pattern: "{variant_name}.slang"
  
  global_inputs:
    - name: outputBuffer
      type: ubuffer
      parameters: "data=[0], stride=4"
      declaration: "RWStructuredBuffer<int> outputBuffer;"

variants:
  cpu-basic:
    description: "CPU compute test"
    directives:
      - type: COMPARE_COMPUTE
        flags: "-cpu -output-using-type"
        filecheck: RESULT
    
    filecheck_patterns:
      RESULT:
        - "12345"
```

### Example: Multi-Backend Texture Test

```yaml
test_config:
  name: texture-types
  shader_template: "./texture-shader.slang"
  output_pattern: "gen-{variant_name}.slang"
  
  global_inputs:
    - name: outputBuffer
      type: ubuffer
      parameters: "data=[0], stride=4"
      declaration: "RWStructuredBuffer<int> outputBuffer;"

variants:
  wgsl-texture2d:
    inputs:
      - name: texHandle
        type: Texture2D
        parameters: "size=4, content=zero"
        declaration: "Texture2D<float4> texHandle;"
    
    directives:
      - type: SIMPLE
        flags: "-entry fragMain -stage fragment -target wgsl"
        filecheck: POSITIVE
      - type: COMPARE_COMPUTE
        flags: "-wgpu"
        filecheck: RESULT
        enabled: false
        disable_reason: 8786
    
    template_vars:
      TEXTURE_OP: "texHandle.Load(int2(0, 0))"
    
    filecheck_patterns:
      POSITIVE:
        - "result code = 0"
      RESULT:
        - "12345"
```

## Schema Validation

The tool validates YAML configuration against the schema defined in `schema/test-config.schema.yaml`.

To validate without generating:

```bash
python slang-test-gen.py config.yaml --validate-only
```

## Generated File Format

Generated test files follow this structure:

```slang
// THIS IS A GENERATED FILE. DO NOT EDIT!
// <generation_comment>
//
// Test: <test_name> - <variant_name>
// <description>
//
//<DISABLE_>TEST:<TYPE>(<filecheck>): <flags>
// Test disabled: <reason or GitHub issue link>

//TEST_INPUT: <type>(<parameters>):name <name>
<declaration>

<additional_header>

<shader_code>

// <filecheck_pattern_name>:
// <pattern>
```

## Differences from Original Generator

The general-purpose generator differs from the texture-specific prototype:

1. **Generic**: Works with any Slang test type, not just textures
2. **Shader input**: Takes shader as argument or template reference
3. **Flexible directives**: Supports all test directive types
4. **Simpler configuration**: Single YAML file instead of multiple config files
5. **Template variables**: Supports variable substitution in shaders
6. **Inline shader code**: Can use inline shader code or external files

## Best Practices

1. **Use external shader templates** for complex shaders
2. **Use template variables** for parameterized tests
3. **Group related variants** in one configuration file
4. **Document disabled tests** with GitHub issue numbers
5. **Validate before generating** to catch configuration errors
6. **Use descriptive variant names** that explain what's being tested
7. **Keep shader templates focused** on the specific functionality being tested

## Schema Reference

See `schema/test-config.schema.yaml` for the complete schema definition with all available options and validation rules.

## Migration from Texture Generator

To migrate from the texture-specific generator:

1. Convert texture types to `inputs` configuration
2. Convert test operations to `template_vars` or inline code
3. Convert backend configs to `variants`
4. Use external shader template or inline code
5. Map test specifications to `directives`

## License

This tool is part of the Slang project. See the main Slang repository for license information.


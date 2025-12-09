#!/usr/bin/env python3
"""
General-Purpose Slang Test Generator

This script generates Slang test files from YAML configuration and shader templates.
It's designed to work with any kind of Slang test, not just texture capability tests.

Usage:
    python slang-test-gen.py <config.yaml> [--output-dir OUTPUT_DIR] [--validate-only]

    config.yaml: YAML configuration file describing the test generation
    --output-dir: Directory to write generated tests (default: current directory)
    --validate-only: Only validate the configuration without generating tests
    --shader: Path to input shader file (overrides config file setting)
"""

import os
import sys
import yaml
import argparse
from pathlib import Path
from typing import Dict, List, Optional, Any, Union
from dataclasses import dataclass, field
from enum import Enum


class TestType(Enum):
    """Types of Slang tests"""
    SIMPLE = "SIMPLE"
    COMPARE_COMPUTE = "COMPARE_COMPUTE"
    INTERPRET = "INTERPRET"
    CROSS_COMPILE = "CROSS_COMPILE"
    COMPILE_FAIL = "COMPILE_FAIL"
    CUSTOM = "CUSTOM"


@dataclass
class TestInput:
    """Represents a test input (buffer, texture, sampler, etc.)"""
    name: str
    input_type: str  # e.g., "ubuffer", "Texture2D", "Sampler"
    parameters: str  # e.g., "data=[0], stride=4", "size=4, content=zero"
    declaration: Optional[str] = None  # Optional Slang declaration

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'TestInput':
        return cls(
            name=data['name'],
            input_type=data['type'],
            parameters=data.get('parameters', ''),
            declaration=data.get('declaration')
        )


@dataclass
class TestDirective:
    """Represents a test directive (//TEST:... line)"""
    test_type: TestType
    flags: str  # Test flags/options
    filecheck: Optional[str] = None  # FileCheck pattern name
    enabled: bool = True
    disable_reason: Optional[str] = None  # GitHub issue number or reason

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'TestDirective':
        test_type_str = data.get('type', 'SIMPLE')
        test_type = TestType[test_type_str] if test_type_str in TestType.__members__ else TestType.CUSTOM

        enabled = data.get('enabled', True)
        disable_reason = data.get('disable_reason')

        return cls(
            test_type=test_type,
            flags=data.get('flags', ''),
            filecheck=data.get('filecheck'),
            enabled=enabled,
            disable_reason=disable_reason
        )

    def to_test_line(self) -> str:
        """Generate the //TEST:... line"""
        prefix = "" if self.enabled else "DISABLE_"

        if self.test_type == TestType.SIMPLE:
            filecheck_part = f"(filecheck={self.filecheck})" if self.filecheck else ""
            return f"//{prefix}TEST:SIMPLE{filecheck_part}: {self.flags}"

        elif self.test_type == TestType.COMPARE_COMPUTE:
            filecheck_part = f"(filecheck-buffer={self.filecheck})" if self.filecheck else ""
            return f"//{prefix}TEST(compute):COMPARE_COMPUTE{filecheck_part}: {self.flags}"

        elif self.test_type == TestType.INTERPRET:
            filecheck_part = f"(filecheck={self.filecheck})" if self.filecheck else ""
            return f"//{prefix}TEST:INTERPRET{filecheck_part}: {self.flags}"

        elif self.test_type == TestType.COMPILE_FAIL:
            return f"//{prefix}TEST:COMPILE_FAIL: {self.flags}"

        elif self.test_type == TestType.CROSS_COMPILE:
            return f"//{prefix}TEST:CROSS_COMPILE: {self.flags}"

        elif self.test_type == TestType.CUSTOM:
            return f"//{prefix}{self.flags}"

        return f"//{prefix}TEST: {self.flags}"


@dataclass
class TestVariant:
    """Represents a test variant (a single test file)"""
    name: str
    description: str
    directives: List[TestDirective]
    inputs: List[TestInput]
    template_vars: Dict[str, Any] = field(default_factory=dict)
    shader_code: Optional[str] = None
    additional_header: Optional[str] = None
    filecheck_patterns: Dict[str, List[str]] = field(default_factory=dict)

    @classmethod
    def from_dict(cls, name: str, data: Dict[str, Any]) -> 'TestVariant':
        directives = [TestDirective.from_dict(d) for d in data.get('directives', [])]
        inputs = [TestInput.from_dict(i) for i in data.get('inputs', [])]
        filecheck_patterns = data.get('filecheck_patterns', {})

        return cls(
            name=name,
            description=data.get('description', ''),
            directives=directives,
            inputs=inputs,
            template_vars=data.get('template_vars', {}),
            shader_code=data.get('shader_code'),
            additional_header=data.get('additional_header'),
            filecheck_patterns=filecheck_patterns
        )


@dataclass
class TestConfig:
    """Main test configuration"""
    name: str
    description: str
    shader_template: str  # Path to shader template or inline shader code
    output_pattern: str  # Output filename pattern (can use {variant_name}, {name}, etc.)
    variants: List[TestVariant]
    global_inputs: List[TestInput] = field(default_factory=list)
    global_template_vars: Dict[str, Any] = field(default_factory=dict)
    generation_comment: Optional[str] = None
    default_filecheck_patterns: Dict[str, List[str]] = field(default_factory=dict)
    default_directives: List[TestDirective] = field(default_factory=list)
    output_dir: Optional[str] = None  # Output directory for generated tests

    @classmethod
    def from_yaml(cls, yaml_path: Path) -> 'TestConfig':
        with open(yaml_path, 'r') as f:
            data = yaml.safe_load(f)

        config = data['test_config']

        # Parse default directives if provided
        default_directives = []
        if 'default_directives' in config:
            default_directives = [
                TestDirective.from_dict(d) for d in config['default_directives']
            ]

        variants = [
            TestVariant.from_dict(name, variant_data)
            for name, variant_data in data.get('variants', {}).items()
        ]

        global_inputs = [
            TestInput.from_dict(i) for i in config.get('global_inputs', [])
        ]

        return cls(
            name=config['name'],
            description=config.get('description', ''),
            shader_template=config['shader_template'],
            output_pattern=config.get('output_pattern', '{name}-{variant_name}.slang'),
            variants=variants,
            global_inputs=global_inputs,
            global_template_vars=config.get('global_template_vars', {}),
            generation_comment=config.get('generation_comment'),
            default_filecheck_patterns=config.get('default_filecheck_patterns', {}),
            default_directives=default_directives,
            output_dir=config.get('output_dir')
        )


class TestGenerator:
    """Generates test files from configuration"""

    def __init__(self, config: TestConfig, config_path: Path, shader_file: Optional[Path] = None):
        self.config = config
        self.config_path = config_path
        self.shader_template = self._load_shader_template(shader_file)

    def _load_shader_template(self, shader_file: Optional[Path]) -> str:
        """Load shader template from file or use inline code"""
        if shader_file:
            with open(shader_file, 'r') as f:
                return f.read()

        # Check if shader_template is a file path
        template_path = Path(self.config.shader_template)
        
        # Try as absolute path first
        if template_path.is_absolute() and template_path.exists():
            with open(template_path, 'r') as f:
                return f.read()
        
        # Try relative to config file directory
        config_dir = self.config_path.parent
        relative_path = config_dir / template_path
        if relative_path.exists():
            with open(relative_path, 'r') as f:
                return f.read()
        
        # Try as relative to current directory
        if template_path.exists():
            with open(template_path, 'r') as f:
                return f.read()

        # Otherwise, treat it as inline shader code
        return self.config.shader_template

    def _apply_template_vars(self, text: str, vars: Dict[str, Any]) -> str:
        """Apply template variable substitution"""
        result = text
        for key, value in vars.items():
            placeholder = f"{{{{{key}}}}}"
            result = result.replace(placeholder, str(value))
        return result

    def _shader_has_test_inputs(self, shader_code: str) -> bool:
        """Check if shader already contains TEST_INPUT directives"""
        return "//TEST_INPUT:" in shader_code

    def _generate_header(self, variant: TestVariant) -> str:
        """Generate test file header"""
        lines = []

        # Generation notice
        if self.config.generation_comment:
            lines.append("// THIS IS A GENERATED FILE. DO NOT EDIT!")
            lines.append(f"// {self.config.generation_comment}")
            lines.append("//")

        # Test description
        lines.append(f"// Test: {self.config.name} - {variant.name}")
        if variant.description:
            lines.append(f"// {variant.description}")
        lines.append("//")

        # Merge default directives with variant directives
        # If variant has directives, use those; otherwise use defaults
        directives = variant.directives if variant.directives else self.config.default_directives
        
        # Add test directives
        for directive in directives:
            test_line = directive.to_test_line()
            lines.append(test_line)

            # Add disable reason as comment if needed
            if not directive.enabled and directive.disable_reason:
                if isinstance(directive.disable_reason, int) or str(directive.disable_reason).isdigit():
                    lines.append(f"// Test disabled, see https://github.com/shader-slang/slang/issues/{directive.disable_reason}")
                else:
                    lines.append(f"// Test disabled: {directive.disable_reason}")

        lines.append("")  # Blank line after directives

        # Add test inputs only if shader doesn't already have them
        if not self._shader_has_test_inputs(self.shader_template):
            all_inputs = self.config.global_inputs + variant.inputs

            for test_input in all_inputs:
                input_line = f"//TEST_INPUT: {test_input.input_type}({test_input.parameters}):name {test_input.name}"
                lines.append(input_line)

                if test_input.declaration:
                    lines.append(test_input.declaration)

            if all_inputs:
                lines.append("")  # Blank line after inputs

        # Add additional header if provided
        if variant.additional_header:
            lines.append(variant.additional_header)
            lines.append("")

        return "\n".join(lines)

    def _generate_filecheck_patterns(self, variant: TestVariant) -> str:
        """Generate FileCheck patterns"""
        # Merge default patterns with variant-specific patterns
        # Variant patterns override defaults
        merged_patterns = {**self.config.default_filecheck_patterns, **variant.filecheck_patterns}
        
        if not merged_patterns:
            return ""

        lines = []
        for pattern_name, patterns in merged_patterns.items():
            for pattern in patterns:
                # If pattern already contains a FileCheck directive (has ':'), use as-is
                # Otherwise, prepend the pattern name
                if ':' in pattern:
                    lines.append(f"// {pattern}")
                else:
                    lines.append(f"// {pattern_name}: {pattern}")
            lines.append("")

        return "\n".join(lines)

    def generate_test_file(self, variant: TestVariant, output_path: Path):
        """Generate a single test file"""
        # Combine global and variant template vars
        template_vars = {**self.config.global_template_vars, **variant.template_vars}

        # Generate header
        header = self._generate_header(variant)

        # Use variant shader code or template
        shader_code = variant.shader_code if variant.shader_code else self.shader_template

        # Apply template variable substitution
        shader_code = self._apply_template_vars(shader_code, template_vars)

        # Generate filecheck patterns
        filecheck = self._generate_filecheck_patterns(variant)

        # Combine all parts
        test_content = header + shader_code

        # Add filecheck patterns at the end if they exist
        if filecheck:
            test_content += "\n\n" + filecheck

        # Ensure no trailing whitespace
        lines = test_content.split('\n')
        lines = [line.rstrip() for line in lines]
        test_content = '\n'.join(lines)

        # Write to file
        with open(output_path, 'w') as f:
            f.write(test_content)

    def generate_all_tests(self, output_dir: Path):
        """Generate all test files"""
        print(f"Generating tests for: {self.config.name}")

        output_dir.mkdir(parents=True, exist_ok=True)

        for variant in self.config.variants:
            # Generate output filename
            filename = self.config.output_pattern.format(
                name=self.config.name,
                variant_name=variant.name
            )
            output_path = output_dir / filename

            try:
                self.generate_test_file(variant, output_path)
                print(f"  ✓ Generated: {filename}")
            except Exception as e:
                print(f"  ✗ Failed to generate {filename}: {e}")
                raise


def validate_config(config_path: Path) -> bool:
    """Validate configuration file"""
    print(f"Validating configuration: {config_path}")

    try:
        config = TestConfig.from_yaml(config_path)
        print(f"  ✓ Configuration loaded successfully")
        print(f"  ✓ Test name: {config.name}")
        print(f"  ✓ Variants: {len(config.variants)}")

        # Validate shader template - check if it looks like a path
        shader_template = config.shader_template.strip()
        
        # Only check if it looks like a file path (not inline code)
        if '\n' not in shader_template and len(shader_template) < 256:
            shader_path = Path(shader_template)
            config_dir = config_path.parent
            relative_path = config_dir / shader_path
            
            if shader_path.is_absolute() and shader_path.exists():
                print(f"  ✓ Shader template found: {shader_path}")
            elif relative_path.exists():
                print(f"  ✓ Shader template found: {relative_path}")
            elif shader_path.exists():
                print(f"  ✓ Shader template found: {shader_path}")
            else:
                # Might be inline or missing file
                print(f"  ℹ Shader template: external file or inline code")
        else:
            print(f"  ℹ Shader template is inline code")

        return True

    except Exception as e:
        print(f"  ✗ Validation failed: {e}")
        import traceback
        traceback.print_exc()
        return False


def find_slang_root(start_path: Path) -> Path:
    """Find the Slang repository root by looking for .git directory"""
    current = start_path.resolve()
    while current != current.parent:
        if (current / '.git').exists():
            return current
        current = current.parent
    # If .git not found, return current working directory
    return Path.cwd()


def main():
    parser = argparse.ArgumentParser(
        description="Generate Slang test files from YAML configuration"
    )
    parser.add_argument('config', type=Path, help='YAML configuration file')
    parser.add_argument('--output-dir', type=Path, default=Path('.'),
                        help='Directory to write generated tests (default: current directory)')
    parser.add_argument('--shader', type=Path,
                        help='Path to shader template file (overrides config setting)')
    parser.add_argument('--validate-only', action='store_true',
                        help='Only validate configuration without generating tests')

    args = parser.parse_args()

    # Validate configuration
    if not validate_config(args.config):
        print("\n✗ Configuration validation failed!")
        sys.exit(1)

    if args.validate_only:
        print("\n✓ Validation successful!")
        sys.exit(0)

    # Load configuration
    config = TestConfig.from_yaml(args.config)

    # Determine output directory: config file takes precedence, then command-line arg
    if config.output_dir:
        # Output dir from config is relative to the Slang repository root
        slang_root = find_slang_root(args.config)
        output_dir = slang_root / config.output_dir
    else:
        output_dir = args.output_dir

    # Generate tests
    generator = TestGenerator(config, args.config, args.shader)
    generator.generate_all_tests(output_dir)

    print(f"\n✓ Test generation complete!")


if __name__ == "__main__":
    main()


#!/usr/bin/env python3
"""
Generate HTML version of ISSUE_ANALYSIS.md with GitHub links and proper styling.
"""

import markdown
import re
import json
from pathlib import Path


def load_pr_numbers():
    """Load PR numbers from data file to distinguish PRs from issues."""
    pr_file = Path(__file__).parent / 'data' / 'pull_requests.json'
    if not pr_file.exists():
        print(f"Warning: {pr_file} not found. All references will link to /issues/")
        return set()

    with open(pr_file) as f:
        prs = json.load(f)

    # Create set of PR numbers
    pr_numbers = {pr['number'] for pr in prs}
    return pr_numbers


def add_github_links(html_content, pr_numbers):
    """Convert issue/PR references to clickable GitHub links.

    Args:
        html_content: HTML string to process
        pr_numbers: Set of PR numbers to distinguish from issues

    Returns:
        HTML with clickable GitHub links
    """
    def replace_number(match):
        number = int(match.group(1))
        url_type = 'pull' if number in pr_numbers else 'issues'
        return f'<a href="https://github.com/shader-slang/slang/{url_type}/{number}" target="_blank">#{number}</a>'

    # Match #1234 pattern (not already in a link)
    # Use negative lookbehind to avoid replacing if already in href
    pattern = r'(?<!href=")(?<!href=\")#(\d+)'
    return re.sub(pattern, replace_number, html_content)


def generate_html():
    """Generate HTML from markdown with GitHub links and styling."""
    # Read the markdown file
    md_file = Path(__file__).parent / 'results' / 'ISSUE_ANALYSIS.md'
    html_file = Path(__file__).parent / 'results' / 'ISSUE_ANALYSIS.html'

    with open(md_file, 'r') as f:
        md_content = f.read()

    # Convert to HTML with extensions
    html_content = markdown.markdown(
        md_content,
        extensions=['extra', 'codehilite', 'toc', 'tables', 'sane_lists']
    )

    # Load PR numbers to distinguish from issues
    pr_numbers = load_pr_numbers()

    # Add GitHub links (with correct /pull/ or /issues/ URLs)
    html_content = add_github_links(html_content, pr_numbers)

    # Create complete HTML document with styling
    html_doc = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Slang Compiler Issue Analysis</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
            line-height: 1.6;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            color: #24292e;
            background-color: #ffffff;
            font-size: 16px;
        }}
        h1 {{
            font-size: 2em;
            border-bottom: 2px solid #e1e4e8;
            padding-bottom: 10px;
            margin-top: 24px;
            font-weight: 600;
        }}
        h2 {{
            font-size: 1.5em;
            border-bottom: 1px solid #e1e4e8;
            padding-bottom: 8px;
            margin-top: 24px;
            font-weight: 600;
        }}
        h3 {{
            font-size: 1.25em;
            margin-top: 20px;
            font-weight: 600;
        }}
        h4 {{
            font-size: 1em;
            margin-top: 16px;
            color: #586069;
            font-weight: 600;
        }}
        p {{
            font-size: 16px;
            margin: 12px 0;
        }}
        strong {{
            font-weight: 600;
            font-size: inherit;
        }}
        em {{
            font-style: italic;
            font-size: inherit;
        }}
        code {{
            background-color: #f6f8fa;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 0.9em;
        }}
        pre {{
            background-color: #f6f8fa;
            padding: 16px;
            border-radius: 6px;
            overflow-x: auto;
            font-size: 14px;
        }}
        pre code {{
            background-color: transparent;
            padding: 0;
        }}
        table {{
            border-collapse: collapse;
            width: 100%;
            margin: 16px 0;
            font-size: 14px;
        }}
        th, td {{
            border: 1px solid #d0d7de;
            padding: 8px 13px;
            text-align: left;
        }}
        th {{
            background-color: #f6f8fa;
            font-weight: 600;
        }}
        tr:nth-child(even) {{
            background-color: #f6f8fa;
        }}
        ul, ol {{
            margin: 8px 0;
            padding-left: 2em;
            font-size: 16px;
        }}
        li {{
            margin: 6px 0;
            line-height: 1.6;
        }}
        ul ul, ol ol, ul ol, ol ul {{
            margin: 4px 0;
            font-size: inherit;
        }}
        ul > li {{
            list-style-type: disc;
        }}
        ul > li > ul > li {{
            list-style-type: circle;
        }}
        ul > li > ul > li > ul > li {{
            list-style-type: square;
        }}
        blockquote {{
            border-left: 4px solid #d0d7de;
            padding-left: 16px;
            margin-left: 0;
            color: #57606a;
            font-size: 16px;
        }}
        a {{
            color: #0969da;
            text-decoration: none;
            font-size: inherit;
        }}
        a:hover {{
            text-decoration: underline;
        }}
        hr {{
            border: none;
            border-top: 1px solid #d0d7de;
            margin: 24px 0;
        }}
        .toc {{
            background-color: #f6f8fa;
            border: 1px solid #d0d7de;
            border-radius: 6px;
            padding: 16px;
            margin: 20px 0;
        }}
        /* Quick summary styling */
        h2#quick-summary {{
            background-color: #ddf4ff;
            border: 1px solid #54aeff;
            border-left: 4px solid #0969da;
            padding: 12px;
            border-radius: 6px;
        }}
    </style>
</head>
<body>
{html_content}
</body>
</html>
'''

    # Write the HTML file
    with open(html_file, 'w') as f:
        f.write(html_doc)

    print(f'✓ HTML file created: {html_file}')
    print(f'  - GitHub links added: {len(pr_numbers)} PRs use /pull/, others use /issues/')
    print(f'  - Professional styling applied')


if __name__ == '__main__':
    generate_html()


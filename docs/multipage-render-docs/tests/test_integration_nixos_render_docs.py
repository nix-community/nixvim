from multipage_render_docs import render_sections
from nixos_render_docs.options import CommonMarkConverter
from nixos_render_docs.types import AnchorStyle


def test_real_converter_accepts_single_option():
    attrs = {
        "options": {
            "section": {
                "test.enable": {
                    "description": "Example option",
                    "loc": ["test"],
                    "readOnly": False,
                    "type": "boolean",
                    "default": {
                        "_type": "literalExpression",
                        "text": "false",
                    },
                }
            }
        }
    }

    converter = CommonMarkConverter(
        {},
        revision="dummy",
        anchor_style=AnchorStyle.LEGACY,
        anchor_prefix="opt-",
    )

    result = render_sections(attrs, converter)

    assert "section" in result
    assert "test.enable" in result["section"]

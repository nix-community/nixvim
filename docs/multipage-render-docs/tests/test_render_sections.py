from types import SimpleNamespace

from multipage_render_docs import render_sections


class FakeConverter:
    def __init__(self):
        self._options = {}

    def add_options(self, options):
        self._options = {
            name: SimpleNamespace(
                loc=name,
                lines=[f"rendered {name}"],
            )
            for name in options
        }

    def _make_anchor_suffix(self, loc):
        return ""


def test_render_sections_preserves_membership():
    attrs = {
        "options": {
            "section-a": {
                "foo.enable": {},
                "foo.package": {},
            },
            "section-b": {
                "bar.enable": {},
            },
        }
    }

    result = render_sections(
        attrs,
        FakeConverter(),
    )

    assert set(result) == {
        "section-a",
        "section-b",
    }

    assert "foo.enable" in result["section-a"]
    assert "foo.package" in result["section-a"]

    assert "bar.enable" not in result["section-a"]

    assert "bar.enable" in result["section-b"]

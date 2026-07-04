from types import SimpleNamespace

from multipage_render_docs import render_option_markdown


class FakeConverter:
    def _make_anchor_suffix(self, loc):
        return f" {{#anchor-{loc}}}"


def test_render_option_markdown():
    rendered = SimpleNamespace(
        loc="foo",
        lines=[
            "line one",
            "line two",
        ],
    )

    result = render_option_markdown(
        FakeConverter(),
        "plugins.example.enable",
        rendered,
    )

    assert result.startswith("## plugins.example.enable {#anchor-foo}")

    assert "line one" in result
    assert "line two" in result

import pytest
from gfm_alerts_to_admonitions import gfm_alert_to_admonition
from markdown_it import MarkdownIt


@pytest.mark.parametrize("kind", ["tip", "note", "important", "warning", "caution"])
def test_parse(data_regression, kind):
    input = f"> [!{kind.upper()}]\n> This is an *alert*"
    md = MarkdownIt("commonmark").use(gfm_alert_to_admonition)
    tokens = md.parse(input)
    data_regression.check([t.as_dict() for t in tokens])


def test_case():
    def make_input(kind):
        return f"> [!{kind}]\n> tip"

    md = MarkdownIt("commonmark").use(gfm_alert_to_admonition)

    reference = [t.as_dict() for t in md.parse(make_input("TIP"))]
    lower = [t.as_dict() for t in md.parse(make_input("tip"))]
    mixed = [t.as_dict() for t in md.parse(make_input("tIp"))]

    assert lower == reference
    assert mixed == reference

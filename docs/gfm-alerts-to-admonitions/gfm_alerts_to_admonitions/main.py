import re
from re import Match

from markdown_it import MarkdownIt
from markdown_it.rules_core import StateCore
from markdown_it.token import Token

_ALERT_PATTERN = re.compile(
    r"^\[\!(TIP|NOTE|IMPORTANT|WARNING|CAUTION)\]\s*", re.IGNORECASE
)


def gfm_alert_to_admonition(md: MarkdownIt):
    def gfm_alert_to_adm(state: StateCore):
        # Scan all tokens, looking for blockquotes,
        # convert any alert-style blockquotes to admonition tokens
        tokens: list[Token] = state.tokens
        for i, token in enumerate(tokens):
            if token.type == "blockquote_open":
                # Store the blockquote's opening token
                open = tokens[i]
                start_index = i

                # Find the blockquote's closing token
                while tokens[i].type != "blockquote_close" and i < len(tokens):
                    i += 1
                close = tokens[i]
                end_index = i

                # Find the first `inline` token in the blockquote
                first_content = next(
                    (
                        t
                        for t in tokens[start_index : end_index + 1]
                        if t.type == "inline"
                    ),
                    None,
                )
                if first_content is None:
                    continue

                # Check if the blockquote is actually an alert
                m: Match = _ALERT_PATTERN.match(first_content.content)
                if m is None:
                    continue

                # Remove ' [!TIP]' from the token's content
                first_content.content = first_content.content[m.end(0) :]

                # Convert the opening & closing tokens from "blockquote" to "admonition"
                open.type = "admonition_open"
                open.meta["kind"] = m.group(1).lower()
                close.type = "admonition_close"

    md.core.ruler.after("block", "github-alerts", gfm_alert_to_adm)

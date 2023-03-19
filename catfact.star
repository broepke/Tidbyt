"""
Applet: Cat Fact
Summary: Cat Fact
Description: Dissplays a Random Cat Fact
Author: broepke
Version: 1.0
References:
    - https://catfact.ninja/
    - https://github.com/tidbyt/community/blob/main/apps/cnnnews/cnn_news.star
"""

load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")

CAT_URL = "https://catfact.ninja/fact"

def main():
    """_summary_

    Returns:
        _type_: _description_
    """
    rep = http.get(CAT_URL)
    if rep.status_code != 200:
        fail("Request failed with status %d", rep.status_code)

    response = rep.json()["fact"]

    return render.Root(
        show_full_animation = True,
        child = render.Column(
            children = [
                render.Box(
                    width = 64,
                    height = 8, 
                    padding = 0,
                    color = "#FFFFFF",
                    child = render.Text("Cat Fact:", offset = 0, color = "#000000"),
                ),
                render.Marquee(
                    height = 24,
                    scroll_direction = "vertical",
                    offset_start = 24,
                    child =
                        render.Column(
                            main_align = "space_between",
                            children = render_text(response),
                        ),
                ),
            ],
        ),

    )

def render_text(fact_text):

    cat_text = []
    cat_text.append(render.WrappedText(fact_text))
    
    return (cat_text)
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

CAT_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAACKADAAQAAAABAAAACAAAAACVhHtSAAAAVElEQVQYGV1OwRGAMAwqPfdzAqfTBXTBmOQOyjWfUCAFxP3GyMF1ojaH/BQR0cZ6JxQ+aNgF8nA3Sd+KAFYFx4ro2OfrY6swZrrXqf+duDSJexdqPwAMIrIbCvXsAAAAAElFTkSuQmCC
""")




def main():
    """_summary_

    Returns:
        _type_: _description_
    """

    fact_cached = cache.get("cat_fact_cached")
    if fact_cached != None:
        print("Hit! Displaying cached data.")
        print(fact_cached)
        response = fact_cached
    else:
        print("Miss! Calling Cat Fact API.")
        rep = http.get(CAT_URL)
        
        if rep.status_code != 200:
            fail("Request failed with status %d", rep.status_code)
        
        print(fact_cached)
        response = rep.json()["fact"]
        cache.set("cat_fact_cached", response, ttl_seconds=240)    

    return render.Root(
        show_full_animation = True,
        child = render.Column(
            children = [
                
                render.Row(
                    expanded=True,
                    main_align = "space_evenly",
                    children = [
                        render.Image(width = 8, height = 8, src = CAT_ICON,
                        ),
                        render.Text(" Cat Fact", offset = 0, color = "#FFFFFF",
                        ),
                    ],
                ),
                
                # render.Box(
                #     width = 64,
                #     height = 8, 
                #     padding = 0,
                #     color = "#FFFFFF",
                #     child = render.Text("Cat Fact:", offset = 0, color = "#000000"),
                # ),

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
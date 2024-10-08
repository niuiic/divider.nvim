local Window = require("divider.outline.window")

-- % new_split %
Window:new_split("left", 10)
Window:new_split("right", 5)
Window:new_split("top", 10)
Window:new_split("bottom", 5)

-- % new_float %
Window:new_float(0, 10, 10, 10, 10)

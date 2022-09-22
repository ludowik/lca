{
    name = "Atmosphere",

    options =
    {
        USE_COLOR = { true },
    },

    properties =
    {
        diffuse = {"vec3", {1, 1, 1}},
        opacity = {"float", 1.0}
    },

    pass =
    {
        files = { "Vertex.vsh", "Fragment.fsh" }
    }
}

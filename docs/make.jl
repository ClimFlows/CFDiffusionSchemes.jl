using CFDiffusionSchemes
using Documenter

DocMeta.setdocmeta!(CFDiffusionSchemes, :DocTestSetup, :(using CFDiffusionSchemes); recursive=true)

makedocs(;
    modules=[CFDiffusionSchemes],
    authors="Thomas Dubos <thomas.dubos@polytechnique.edu> and contributors",
    sitename="CFDiffusionSchemes.jl",
    format=Documenter.HTML(;
        canonical="https://dubosipsl.github.io/CFDiffusionSchemes.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/dubosipsl/CFDiffusionSchemes.jl",
    devbranch="main",
)

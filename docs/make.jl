using NularevNumberSolver
using Documenter

DocMeta.setdocmeta!(
    NularevNumberSolver,
    :DocTestSetup,
    :(using NularevNumberSolver);
    recursive = true,
)

makedocs(;
    modules = [NularevNumberSolver],
    authors = "Laine Taffin Altman <alexanderaltman@me.com> and contributors",
    sitename = "NularevNumberSolver",
    format = Documenter.HTML(;
        canonical = "https://pthariensflame.github.io/nularev-number-solver",
        edit_link = "main",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
)

deploydocs(; repo = "github.com/pthariensflame/nularev-number-solver", devbranch = "main")

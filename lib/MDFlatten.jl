module MDFlatten

export mdflatten

import Base.Markdown:
    MD, BlockQuote, Bold, Code, Header, HorizontalRule,
    Image, Italic, LaTeX, LineBreak, Link, List, Paragraph, Table

"""
Convert a Markdown object to a `String` of only text (i.e. not formatting info).

It drop most of the extra information (e.g. language of a code block, URLs)
and formatting (e.g. emphasis, headers). This "flattened" representation can
then be used as input for search engines.
"""
function mdflatten(md)
    io = IOBuffer()
    mdflatten(io, md)
    takebuf_string(io)
end

mdflatten(io, md) = mdflatten(io, md, md)
mdflatten(io, md::MD, parent) = mdflatten(io, md.content, md)
mdflatten(io, vec::Vector, parent) = map(x->mdflatten(io, x, parent), vec)
function mdflatten(io, vec::Vector, parent::MD)
    # this special case separates top level blocks with newlines
    for md in vec
        mdflatten(io, md, parent)
        print(io, "\n\n")
    end
end

# Block level MD nodes
mdflatten{N}(io, h::Header{N}, parent) = mdflatten(io, h.text, h)
mdflatten(io, p::Paragraph, parent) = mdflatten(io, p.content, p)
mdflatten(io, bq::BlockQuote, parent) = mdflatten(io, bq.content, bq)
mdflatten(io, ::HorizontalRule, parent) = nothing
function mdflatten(io, list::List, parent)
    for (idx,li) in enumerate(list.items)
        for (jdx,x) in enumerate(li)
            mdflatten(io, x, list)
            jdx != length(li) && print(io, '\n')
        end
        idx != length(list.items) && print(io, '\n')
    end
end
function mdflatten(io, t::Table, parent)
    for (idx,row) = enumerate(t.rows)
        for (jdx,x) in enumerate(row)
            mdflatten(io, x, t)
            jdx != length(row) && print(io, ' ')
        end
        idx != length(t.rows) && print(io, '\n')
    end
end

# Inline nodes
mdflatten(io, text::AbstractString, parent) = print(io, text)
mdflatten(io, link::Link, parent) = mdflatten(io, link.text, link)
mdflatten(io, b::Bold, parent) = mdflatten(io, b.text, b)
mdflatten(io, i::Italic, parent) = mdflatten(io, i.text, i)
mdflatten(io, i::Image, parent) = print(io, "[image: $(i.alt) ($(i.url))]")
mdflatten(io, m::LaTeX, parent) = print(io, "[latex: m.formula]")
mdflatten(io, ::LineBreak, parent) = print(io, '\n')

# Is both inline and block
mdflatten(io, c::Code, parent) = print(io, c.code)

# Special (inline) "node" -- due to JuliaMark's interpolations
mdflatten(io, expr::Union{Symbol,Expr}, parent) = print(io, expr)


# Only available on Julia 0.5.
if isdefined(Base.Markdown, :Footnote)
    import Base.Markdown: Footnote
    mdflatten(io, f::Footnote, parent) = footnote(io, f.id, f.text, parent)
    footnote(io, id, text::Void, parent) = print(io, "[$id]")
    function footnote(io, id, text, parent)
        print(io, "[$id]: ")
        mdflatten(io, text, parent)
    end
end

if isdefined(Base.Markdown, :Admonition)
    import Base.Markdown: Admonition
    function mdflatten(io, a::Admonition, parent)
        println(io, "$(a.category): $(a.title)")
        mdflatten(io, a.content, a)
    end
end

end

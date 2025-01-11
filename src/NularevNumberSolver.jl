module NularevNumberSolver

export Term, SumOfTerms, translate, joinparts

struct Term
  twos::UInt
  threes::UInt
  fives::UInt
  sevens::UInt
  Term(; twos = 0, threes = 0, fives = 0, sevens = 0) =
    new(convert(UInt, twos), convert(UInt, threes), convert(UInt, fives), convert(UInt, sevens))
end

struct SumOfTerms
  terms::Vector{Term}
  SumOfTerms(terms::Term...) = new(Term[terms...])
end

Term(other::Term) = other
Base.one(::Type{Term}) = Term()
Base.iszero(term::Term)::Bool = false
Base.isone(term::Term)::Bool =
 iszero(term.twos) && iszero(term.threes) && iszero(term.fives) && iszero(term.sevens)
Base.convert(::Type{T}, term::Term) where {T<:Number} =
  *(convert(T, 2)^(term.twos), convert(T, 3)^(term.threes), convert(T, 5)^(term.fives), convert(T, 7)^(term.sevens))
(::Type{T})(term::Term) where {T<:Number} = convert(T, term)
Base.:*(x::Term, y::Term) =
  Term(twos = x.twos + y.twos, threes = x.threes + y.threes, fives = x.fives + y.fives, sevens = x.sevens + y.sevens)
Base.:+(x::Term, y::Term) = SumOfTerms(x, y)

SumOfTerms(other::SumOfTerms) = other
Base.zero(::Type{SumOfTerms}) = SumOfTerms()
Base.one(::Type{SumOfTerms}) = SumOfTerms(Term())
Base.iszero(terms::SumOfTerms)::Bool = isempty(terms.terms)
Base.isone(terms::SumOfTerms)::Bool =
 isone(length(terms.terms)) && isone(only(terms.terms))
Base.convert(::Type{SumOfTerms}, term::Term) = SumOfTerms(term)
Base.convert(::Type{T}, terms::SumOfTerms) where {T<:Number} = sum(convert.(T, terms.terms))
(::Type{T})(terms::SumOfTerms) where {T<:Number} = convert(T, terms)
Base.:+(x::SumOfTerms, y::SumOfTerms) = SumOfTerms(x.terms..., y.terms...)

function translate(term::Term; isinitial::Bool)::Vector{String}
  if isone(term)
    if isinitial
      return ["tov"]
    else
      return String[]
    end
  end

  return [fill("mem", term.twos); fill("let", term.threes); fill("zhain", term.fives); fill("wat", term.sevens)]
end
function translate(terms::SumOfTerms)::Vector{String}
  isempty(terms.terms) && return ["x⃘eth"]
  initial, remaining = Iterators.peel(terms.terms)
  result::Vector{String} = translate(initial, isinitial=true)
  for term in remaining
    append!(result, ["tov"])
    append!(result, translate(term; isinitial=false))
  end
  return result
end

function joinparts(parts::Vector{String})::String
  result::String, remaining = Iterators.peel(parts)
  for part in remaining
    # no need to worry about digraphs here because of the limited vocabulary
    if last(result) == first(part)
      result *= part[begin+1:end]
    else
      result *= part
    end
  end
  return result
end

end

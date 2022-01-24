using Symbolics
using Symbolics: symbol_to_poly, poly_to_symbol

using Test

@variables x y z

syms = [
    [1], [1, BigInt(2)], [x], [x^2 + 2], [x + (5//8)y],
    [1 - x*y*z], [(x + y + z)^5], [0, BigInt(0)y^2, Rational(1)z^3]
]
for sym in syms
    poly, sym2poly = Symbolics.symbol_to_poly(sym, true)
    sym2 = Symbolics.poly_to_symbol(poly, sym2poly)
    @test isequal(sym2, expand.(sym))
end

@test isequal(groebner_basis([x]), [x])
@test isequal(groebner_basis([x, y]), [y, x])
@test isequal(groebner_basis([y, x]), [y, x])
@test isequal(groebner_basis([x, x^2]), [x])
@test isequal(groebner_basis([BigInt(1)x + 2//3]), [x  + 2//3])

@variables x1 x2 x3 x4
@test isequal(groebner_basis([x1, x, y]), [y, x1, x])

@variables x1 x2 x3 x4 x5
system = [
   x1 + x2 + x3 + x4 + x5,
   x1*x2 + x1*x3 + x1*x4 + x1*x5 + x2*x3 + x2*x4 + x2*x5 + x3*x4 + x3*x5 + x4*x5,
   x1*x2*x3 + x1*x2*x4 + x1*x2*x5 + x1*x3*x4 + x1*x3*x5 + x1*x4*x5 + x2*x3*x4 + x2*x3*x5 + x2*x4*x5 + x3*x4*x5,
   x1*x2*x3*x4 + x1*x2*x3*x5 + x1*x2*x4*x5 + x1*x3*x4*x5 + x2*x3*x4*x5,
   x1*x2*x3*x4*x5 - 1
]
truebasis = [
        x1 + x2 + x3 + x4 + x5,
        x2^2 + x2*x3 + x2*x4 + x2*x5 + x3^2 + x3*x4 + x3*x5 + x4^2 + x4*x5 + x5^2,
        x3^3 + x3*(x4^2) + x3*(x5^2) + x4^3 + x4*(x3^2) + x5*(x4^2) + x4*(x5^2) + x5^3 + x5*(x3^2) + x3*x4*x5,
        x4^4 + x4*(x5^3) + x5^4 + x5*(x4^3) + (x4^2)*(x5^2),
        x5^5 - 1
]
basis = groebner_basis(system)
@test isequal(basis, truebasis)

# Groebner does not yet work with constant ideals
@test_broken groebner_basis([1])

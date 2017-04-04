import Base: +, -, *, /, \, ^, sqrt, cbrt,
    sin, cos, tan,
    sind, cosd, tand, sinpi, cospi,
    sec, csc, cot,
    secd, cscd, cotd,
    asin, acos, atan,
    asind, acosd, atand,
    sinh, cosh, tanh,
    asinh, acosh, atanh,
    log, log2, log10, log1p,
    exp, exp2, exp10, expm1,
    deg2rad, rad2deg, significand

# atan2, asind, acosd, atand, asec, acsc,
# acot, asecd, acscd, acotd, sech, csch, coth, asech, acsch, acoth,
# sinc, cosc, hypot,
# min, max, minmax, clamp, abs, abs2, copysign, sign, flipsign, erf, erfc, erfx
# erfinv, erfcinv, real, imag, reim, conj, angle, cis, gamma, lgamma, lfact, digamma, invdigamma,
# trigamma, polygamma, airy, airyprime, airyaiprime, airybi, airybiprime, airyx, + all of the other special functions.

lb, ub = -5., 5.
π180 = π / 180


# Definitions for functions of a single argument written as y = f(x).
unary_sensitivities = [
    (:-,     :(-ȳ),                       (lb, ub)),
    (:sin,   :(ȳ .* cos(x)),               (lb, ub)),
    (:cos,   :(-ȳ .* sin(x)),              (lb, ub)),
    (:tan,   :(ȳ .* (1 .+ abs2(y))),        (lb, ub)),
    (:sind,  :(ȳ .* π180 .* cosd(x)),   (lb, ub)),
    (:cosd,  :(-ȳ .* π180 .* sind(x)),  (lb, ub)),
    (:tand,  :(ȳ .* π180 .* (1 .+ y.^2)), (lb, ub)),
    (:sinpi, :(ȳ .* π .* cospi(x)),         (lb, ub)),
    (:cospi, :(-ȳ .* π .* sinpi(x)),        (lb, ub)),
    (:cot,   :(-ȳ .* csc(x).^2),            (lb, ub)),
    (:sec,   :(ȳ .* y .* tan(x)),           (lb, ub)),
    (:csc,   :(-ȳ .* y .* cot(x)),          (lb, ub)),
    (:cotd,  :(-ȳ .* π180 .* cscd(x).^2), (lb, ub)),
    (:secd,  :(ȳ .* y .* π180 .* tand(x)), (lb, ub)),
    (:cscd,  :(-ȳ .* y .* π180 .* cotd(x)),(lb, ub)),
    (:acos,  :(-ȳ ./ sqrt(1 .- abs2(x))),  (-1., 1.)),
    (:asin,  :(ȳ ./ sqrt(1 .- abs2(x))),    (-1., 1.)),
    (:atan,  :(ȳ ./ (1 .+ abs2(x))),        (lb, ub)),
    # (:acosd, :(-ȳ * π / (180 * sqrt(1. - abs2(deg2rad(x))))),  (-rad2deg(1.), rad2deg(1.))),
    # (:asin,  :(ȳ / sqrt(1 - abs2(x))),    (-1., 1.)),
    # (:atan,  :(ȳ / (1 + abs2(x))),        (lb, ub)),
    (:sinh,  :(ȳ .* cosh(x)),              (lb, ub)),
    (:cosh,  :(ȳ .* sinh(x)),              (lb, ub)),
    (:tanh,  :(ȳ ./ cosh(x).^2),            (lb, ub)),
    (:acosh, :(ȳ ./ sqrt(abs2(x) .- 1.)),   (1., ub)),
    (:asinh, :(ȳ ./ sqrt(1. .+ abs2(x))),   (lb, ub)),
    (:atanh, :(ȳ ./ (1. .- abs2(x))),       (-1. ,1.)),
    (:log,   :(ȳ ./ x),                    (0., ub)),
    (:log2,  :(ȳ ./ (x .* log(2))),         (0., ub)),
    (:log10, :(ȳ ./ (x .* log(10))),        (0., ub)),
    (:log1p, :(ȳ ./ (1. .+ x)),             (0., ub)),
    (:exp,   :(ȳ .* y),                    (lb, ub)),
    (:exp2,  :(ȳ .* y .* log(2)),           (lb, ub)),
    (:exp10, :(ȳ .* y .* log(10)),          (lb, ub)),
    (:expm1, :(ȳ .* (y .+ 1.)),             (lb, ub)),
    (:sqrt,  :(ȳ ./ (2 .* y)),              (0., ub)),
    (:cbrt,  :(ȳ ./ (3. .* abs2(y))),      (lb, ub)),
    (:deg2rad, :(ȳ .* π180),         (lb, ub)),
    (:rad2deg, :(ȳ ./ π180),        (lb, ub)),
    (:significand, :(ȳ .* 0.5.^exponent(x)), (lb, ub)),
]

for (f, x̄, range) in unary_sensitivities
    @eval @primitive $f{T<:AbstractFloat}(x::T) y ȳ $x̄
end

# Definitions for functions of two arguments written as z = f(x, y).
binary_sensitivities = [
    (:+, :(z̄),                   :(z̄),                (lb, ub), (lb, ub)),
    (:-, :(z̄),                   :(-z̄),               (lb, ub), (lb, ub)),
    (:*, :(z̄ * y),               :(z̄ * x),            (lb, ub), (lb, ub)),
    (:/, :(z̄ / y),               :(-z̄ * x / y^2),     (lb, ub), (lb, ub)),
    (:\, :(-z̄ * y / x^2),        :(z̄ / x),            (lb, ub), (lb, ub)),
    # (:^, :(z̄ * (y - 1) * z / x), :(z̄ * z * log(x)),   (0., ub), (lb, ub)),
]

for (f, x̄, ȳ, range) in binary_sensitivities
    @eval @primitive $f{T, V<:AbstractFloat}(x::T, y::V) z z̄ $x̄ $ȳ
end

# Other functions defined in julia/base/math.jl
# frexp: returns tuple
# minmax: returns tuple
# modf: returns tuple
# Moved to erf.jl:
# erf: see erf.jl
# erfc: see erf.jl
# Moved to gamma.jl:
# (lgamma, :(digamma(x)), (-Inf,Inf)),


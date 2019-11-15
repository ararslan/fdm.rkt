# fdm.rkt

[![Travis](https://travis-ci.org/ararslan/fdm.rkt.svg?branch=master)](https://travis-ci.org/ararslan/fdm.rkt)
[![Coveralls](https://coveralls.io/repos/github/ararslan/fdm.rkt/badge.svg?branch=master)](https://coveralls.io/github/ararslan/fdm.rkt?branch=master)

[Finite difference](https://en.wikipedia.org/wiki/Finite_difference) methods for
estimating derivatives in Racket.
The API is loosely based on that of [fdm](https://github.com/wesselb/fdm) and
[FiniteDifferences.jl](https://github.com/invenia/FiniteDifferences.jl) (née FDM.jl).
This package provides a small subset of the functionality provided by those.

## API

```racket
(forward-grid p)
(backward-grid p)
(central-grid p)
```

These functions define the grids for a forward, backward, or central finite difference
method of order `p`.

```racket
(dfdx g p q f x
      #:adapt
      #:condition
      #:eps
      #:bound)
```

Compute the `q`th derivative of the univariate, real-valued function `f` at `x` using a
finite difference method of order `p` with a grid defined by `g`.
`g` should be one of the aforementioned functions.
The keyword arguments are:

* `adapt`: The number of adaptive steps to use to improve the estimate of `bound`.
  Defaults to 1. Set to 0 to disable adaptive bound computation.
* `condition`: The [condition number](https://en.wikipedia.org/wiki/Condition_number)
  used when computing bounds. Defaults to 100.
* `eps`: The assumed roundoff error. Defaults to `epsilon.0`.
* `bound`: Bound on the value of the function `f` and its derivatives at `x`. This
  value is computed and should not generally need to be specified.

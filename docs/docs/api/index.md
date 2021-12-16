# API

## Note on reproducibility

Functions marked with $^\star$ are stochastic. Thus, in order to obtain the same
result on separate invocations of these functions, it is first necessary to
define a seed for the pseudo-random number generator (PRNG). This can be
accomplished in slightly different ways in MATLAB and Octave:

```{.matlab title="MATLAB"}
rng(123);
```

```{.matlab title="GNU Octave"}
rand("state", 123);
randn("state", 123);
```

## Main function

* [`clugen`](clugen) $^\star$

## Core functions

* [`points_on_line`](points_on_line)
* [`rand_ortho_vector`](rand_ortho_vector)  $^\star$
* [`rand_unit_vector`](rand_unit_vector)  $^\star$
* [`rand_vector_at_angle`](rand_vector_at_angle)  $^\star$

## Algorithm module functions

* [`angle_deltas`](angle_deltas) $^\star$
* [`clucenters`](clucenters) $^\star$
* [`clupoints_n_1`](clupoints_n_1) $^\star$
* [`clupoints_n`](clupoints_n) $^\star$
* [`clusizes`](clusizes) $^\star$
* [`llengths`](llengths) $^\star$

## Algorithm module helper functions

* [`clupoints_n_1_template`](clupoints_n_1_template) $^\star$
* [`fix_empty`](fix_empty)
* [`fix_num_points`](fix_num_points)

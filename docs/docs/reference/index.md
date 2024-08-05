# Reference

## Note on reproducibility

Functions marked with $^\star$ are stochastic. Thus, in order to obtain the same
result on separate invocations of these functions, it is first necessary to
define a seed for the pseudo-random number generator (PRNG). Since this is
accomplished in slightly different ways in MATLAB and Octave, `MOCluGen`
provides the [`cluseed`](cluseed) helper function for setting the PRNG seed
regardless of the underlying platform. For example:

```matlab
cluseed(123);
v = rand_unit_vector(3); % Given the same platform, will always return the same vector
```

Further, the main [`clugen`](clugen) function also provides a `seed` parameter,
which is passed directly to [`cluseed`](cluseed).

## Main functions

* [`clugen`](clugen) $^\star$
* [`clumerge`](clumerge)

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

## Helper functions

* [`angle_btw`](angle_btw)
* [`clupoints_n_1_template`](clupoints_n_1_template) $^\star$
* [`cluseed`](cluseed)
* [`fix_empty`](fix_empty)
* [`fix_num_points`](fix_num_points)

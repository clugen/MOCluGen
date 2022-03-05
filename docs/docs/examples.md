# Examples

## Examples in 2D

### Manipulating the direction of cluster-supporting lines

#### Using the `direction` parameter

```matlab
% Seed set to 123 before each call to clugen()
e01 = clugen(2, 4, 200, [1; 0], 0, [10; 10], 10, 1.5, 0.5);
e02 = clugen(2, 4, 200, [1; 1], 0, [10; 10], 10, 1.5, 0.5);
e03 = clugen(2, 4, 200, [0; 1], 0, [10; 10], 10, 1.5, 0.5);

plot2d(e01, 'e01: direction = [1; 0]', e02, 'e02: direction = [1; 1]', e03, 'e03: direction = [0; 1]');
```

![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e01e02e03.svg)

# Welcome to MOCluGen Docs!!

Here's an inline math thing $y=mx+b$.

Some MATLAB code with explicit tag:

```matlab
function ma = minangle(a)
    ma = atan2(sin(a), cos(a));
    if ma > pi/2
        ma = ma - pi;
    elseif ma < -pi/2
        ma = ma + pi;
    end;
end
```

MATLAB code with indented code block:

    function ma = minangle(a)
        ma = atan2(sin(a), cos(a));
        if ma > pi/2
            ma = ma - pi;
        elseif ma < -pi/2
            ma = ma + pi;
        end;
    end

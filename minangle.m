
%%
function ma = minangle(a)
    ma = atan2(sin(a), cos(a));
    if ma > pi/2
        ma = ma - pi;
    elseif ma < -pi/2
        ma = ma + pi;
    end
end

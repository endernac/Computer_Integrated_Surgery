function inRange = check_equal(a, b)
% checks if a == b within some range eps
eps = 0.000001;

inRange = (abs(a - b) < eps);

end
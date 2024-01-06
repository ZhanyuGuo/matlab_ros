function [v, w] = controller(state, target)
    k = 1.0;
    l = 0.2; % d of the robot
    e_x = target(1) - state(1);
    e_y = target(2) - state(2);
    u_x = k * e_x;
    u_y = k * e_y;
    A = [cos(state(3)), -l * sin(state(3));
         sin(state(3)), l * cos(state(3))];
    U = [u_x; u_y];
    v_w = A \ U;
    v = v_w(1);
    w = v_w(2);
end

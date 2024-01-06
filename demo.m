clear; close all; clc;

% Note: Have a master before

% Initialize ROS node
% setenv('ROS_MASTER_URI', 'http://10.1.1.4:11311');  % Master IP
% setenv('ROS_IP', '10.1.1.4');  % Local IP
setenv('ROS_MASTER_URI', 'http://127.0.0.1:11311'); % Master IP
setenv('ROS_IP', '127.0.0.1'); % Local IP

% node_name = 'stabilization_demo';
% rosinit('NodeName', node_name);
rosinit; % anonymous

% Create subscriber for odom topic
% odom_sub = rossubscriber('/odom', @odomCallback, 'DataFormat', 'struct');
% NOTE: You can use x, y, theta anywhere, as they are global variables

odom_sub = rossubscriber('/odom', 'DataFormat', 'struct');
[odom_msg, ~, ~] = receive(odom_sub, 10);
state = getPose(odom_msg); % state = [x, y, theta]

% Create publisher for velocity commands
vel_pub = rospublisher('/cmd_vel', 'DataFormat', 'struct');
vel = rosmessage(vel_pub);

% eg., set desired velocity values
% vel.Linear.X = 0.1;  % Forward velocity
% vel.Angular.Z = 0.5; % Angular velocity

epsilon = 0.05;
target = [1.0; 1.0];

rate = rateControl(10); % Rate of publishing velocity commands (10 Hz)

while sqrt((target(1) - state(1)) .^ 2 + (target(2) - state(2)) .^ 2) > epsilon
    [odom_msg, ~, ~] = receive(odom_sub, 10);
    state = getPose(odom_msg)

    %% Design your controller here %%
    [v, w] = controller(state, target);

    vel.Linear.X = v;
    vel.Angular.Z = w;

    %% Send velocity command
    send(vel_pub, vel);

    % Wait for next iteration
    waitfor(rate);
end

% Stop the robot by sending zero velocity command
vel.Linear.X = 0;
vel.Angular.Z = 0;
send(vel_pub, vel);

% Shutdown ROS
rosshutdown;

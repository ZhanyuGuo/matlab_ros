function state = getPose(odom_msg)
    state = zeros(3, 1);
    pose = odom_msg.Pose.Pose;
    x = pose.Position.X;
    y = pose.Position.Y;

    quat = pose.Orientation;
    angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
    theta = angles(1);

    state(1) = x;
    state(2) = y;
    state(3) = theta;
end

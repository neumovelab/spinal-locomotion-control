function v_plateXZ = fn_terrainSlope(terrainL, angle)

v_plateX = [0 terrainL];

for i = 1:length(v_plateX)
    v_plateZ(i) = v_plateX(i)*tan(angle);
end

% plot(v_plateX, v_plateZ)
v_plateXZ = [v_plateX; v_plateZ];

end

        
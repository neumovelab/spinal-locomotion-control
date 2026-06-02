function ground = fn_createSlope(angle)

    scale   = angle;
    
    v_plateXZ = fn_terrainSlope(100000, scale);     
    
    v_plateX = v_plateXZ(1,:);
    v_plateZ = v_plateXZ(2,:);
    v_delX = v_plateX(2:end) - v_plateX(1:end-1);
    v_delZ = v_plateZ(2:end) - v_plateZ(1:end-1);
    v_plateS = atan2(v_delZ,v_delX);
    
    ground.v_plateXZ        = v_plateXZ;
    ground.v_plateS         = v_plateS;

end
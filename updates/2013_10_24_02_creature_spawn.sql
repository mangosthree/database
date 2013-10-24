-- updated warrior trainer spawn in stormwind city
UPDATE creature SET position_x = '-8790.117188', position_y = '344.001465', position_z = '118.007133', orientation = '3.933309' WHERE guid = '188754';

-- spawned missing druid trainer in stormwind
DELETE FROM creature WHERE guid=400001;
INSERT INTO creature VALUES (400001,44395,0,1,1,0,44395,-8319.42,484.67,124.38,6.02493,25,0,0,1226,1283,0,0);

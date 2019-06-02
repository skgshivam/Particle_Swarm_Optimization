function z = Cost_function(i,particle,npop)
    alpha = 0.4;
    beta = 0.4;
    gamma = 0.19;
    avg_distance = 0;
    avg_energy = 0;
    for j = 1:npop
       if particle(j).Alive ==1
       x =  (particle(j).Position(1) - particle(i).Position(1)).*(particle(j).Position(1) - particle(i).Position(1));
       y = (particle(j).Position(2) - particle(i).Position(2)).*(particle(j).Position(2) - particle(i).Position(2));
       avg_distance = avg_distance + sqrt(x + y);
       end
    end
    avg_distance = avg_distance/npop;
    for j = 1:npop
       if particle(j).Alive ==1 
        avg_energy = avg_energy + particle(j).Energy;
       end
    end
    avg_energy = avg_energy/particle(i).Energy;
    x =  (particle(i).Position(1) - 20).*(particle(i).Position(1) - 20);
    y = (particle(i).Position(2) - 20).*(particle(i).Position(2) - 20);
    avg_distance1 = sqrt(x + y);
    z = alpha.*avg_distance + beta.*avg_energy+gamma.*avg_distance1;
end

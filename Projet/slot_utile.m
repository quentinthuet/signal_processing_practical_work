function x_utile = slot_utile(x_base_filtre,Ns,Nb)
    max_puissance = 0;
    
    for i = 1:5
        x_courant = x_base_filtre((i-1)*Ns*Nb+1: i*Ns*Nb);
        puissance_courant = mean(x_courant.*x_courant);
        if puissance_courant > max_puissance
            x_utile = x_courant;
            max_puissance = puissance_courant;
        end
    end 
end
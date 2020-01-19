% Nom : slot_utile
% But : Calcul du slot utile d'un signal MF-TDMA apres retour en bande de
% base
% Paramètres : 
%   - x_base_filtre : le signal dont on veut detecter le slot utile
%   - Ns : le nombre d'echantillons par bit de x_base_filtre
%   - Nb : le nombre de bit total de x_base_filtre
% Retour :
%   - Le numéro du slot utile
function x_utile = slot_utile(x_base_filtre,Ns,Nb)
    
    max_puissance = 0;
    
    for i = 1:5
        % Selection du slot
        x_courant = x_base_filtre((i-1)*Ns*Nb+1: i*Ns*Nb);
        % Calcul de la puissance du slot
        puissance_courant = mean(x_courant.*x_courant);
        % Comparaison avec la valeur maximale précédente
        if puissance_courant > max_puissance
            x_utile = x_courant;
            max_puissance = puissance_courant;
        end
    end 
end
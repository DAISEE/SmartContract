contract Daisee {

    Usager[] public usagers;
    uint public currentTime;
    uint prixKwh;

    /* Usagers */
    struct Usager {
        address addr;
        uint[] conso;
        uint[] prod;
        uint[] disponible;

        string nom;
        uint credit;
    }

    Usager anusager;

    /*  Initialisation */
    function Daisee() {
        currentTime = 0;
    }   


    function () {
        bool trouve=false;

        for (uint i = 0; i < usagers.length; ++i) {
            if(usagers[i].addr == msg.sender){
                usagers[i].credit = usagers[i].credit + msg.value;
                trouve=true;
            }
        }  
        if(trouve){

        }else {
            throw;
        }

    }

    function sajouterUsager(
        string name
        ) {
        Usager nouvelUsager = anusager;
        nouvelUsager.nom = name;
        nouvelUsager.credit = msg.value;
        nouvelUsager.addr = msg.sender;


        usagers[usagers.length++] = nouvelUsager;

        // {addr: msg.sender, credit: msg.value, nom: name, conso:[0], prod: [0], disponible:[0]}
        for (uint i = 0; i < currentTime; ++i) {
            usagers[usagers.length].conso[i]=0;  
            usagers[usagers.length].prod[i]=0;
            usagers[usagers.length].disponible[i]=0;
        } 
    }

    function publier(uint consoActuelle, uint prodActuelle) {
        uint prodDiff = prodActuelle - consoActuelle;
        // address vendeur;
        bool termine;

        for (uint i = 0; i < usagers.length; ++i) {
            if(usagers[i].addr == msg.sender){
                usagers[i].conso[currentTime] = consoActuelle;
                usagers[i].prod[currentTime] = prodActuelle;

                if(prodDiff>0){
                    usagers[i].disponible[currentTime] = prodDiff;
                } else {
                    for (uint j = 0; j < usagers.length; ++j) {
                        if(usagers[j].disponible[currentTime-1]> 0){
                            // vendeur = usagers[j].addr;
                            uint dispo;

                            if (prodDiff > dispo){
                                usagers[j].disponible[currentTime-1] = 0;
                                usagers[j].credit +=  dispo * prixKwh;
                                usagers[i].credit -=  dispo * prixKwh;
                                prodDiff -= dispo;
                            }else {
                                usagers[j].disponible[currentTime-1] -= prodDiff;
                                usagers[j].credit +=  prodDiff * prixKwh;
                                usagers[i].credit -=  prodDiff * prixKwh;

                                termine = true;
                                return;
                            }
                        }
                    }
                    if(termine){

                    }else{
                        /*Acheter hors reseau */
                    }

                }
            }
        } 
    }

    function nextTime() {
        currentTime++; 
    }

}
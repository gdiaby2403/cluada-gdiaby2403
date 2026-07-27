docker compose down -v : efface les volumes en cas de bugs ET aussi utile quand on modifie sa base de données
penser à faire cette commande   
docker compose up -d : à faire après le docker compose down -v
Quand on choisit un port parmi les ports docker commencer par 1024
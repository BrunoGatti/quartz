## Esercizio 1:

Fate un programma in C che prende in input un numero non specificato di punti del piano cartesiano.
Presi questi punti, ad esempio A,B,C e D. Calcola il perimetro del poligono ABCD.

![[Pasted image 20231212120852.png]]

Ad esempio potresti inserire questi sei punti. E voler calcolare il perimetro.

Il programma deve prendere in input:
- un numero di punti imprecisato
- calcolare la distanza tra questi punti
- sommarle per trovare il perimetro

Buon Lavoro: qui sotto c'è la soluzione.

>[!hint]- soluzione
>```C
>#include<stdio.h>
>#include<stdlib.h>
>#include<math.h>
>
>struct Punto {
>   float x;
>   float y;
>};typedef struct Punto punto;
>
>float distanza_tra_due_punti(punto a, punto b);
>float perimetro(punto ** lista_di_punti,int  dimensione_lista);
>void stampa_punto(punto p,char * nome_del_punto);
>void stampa_lista_di_punti(punto ** lista_di_punti,int dimensione);
>punto ** append(punto ** lista_di_punti,int numero_punti,punto * p);
>punto * alloca_punto(float x, float y);
>
>int main(){
>   float x;
>   float y;
>   punto *p;
>   punto ** lista_di_punti=malloc(sizeof(punto *));
>   if(lista_di_punti==NULL){return 0;}
>   int numero_punti=0;
>       //chiedere all'utente le coordinate
>       printf("inserire la x del punto: ");
>       if(scanf("%f",&x)!=1){break;}
>
>       //alloca il punto
>       p=alloca_punto(x,y);
>       numero_punti++;
>
>       //aggiungi il punto alla lista dei punti
>       lista_di_punti = append(lista_di_punti,numero_punti,p);
>
>       //stampa la lista dei punti
>       stampa_lista_di_punti(lista_di_punti,numero_punti);
>   }
>   //stampo la lista dei punti per verificare che siano tutti stati inseriti correttamente
>   stampa_lista_di_punti(lista_di_punti,numero_punti);
>
>   //stampo il perimetro del poligono
>   printf("il perimetro del poligono tracciato è: %f\n",perimetro(lista_di_punti,numero_punti));
>
>   //libero la lista di punti una volta finito le operazioni
>   free(lista_di_punti);
>
>
>
>}
>
>float distanza_tra_due_punti(punto a, punto b){
>   return sqrt(pow((a.x-b.x),2)+pow((a.y-b.y),2));
>}
>
>float perimetro(punto ** lista_di_punti,int  dimensione_lista){
>   float perimetro=0;
>   int j=0;
>
>   //per ogni coppia di punti in sequenza
>   for(int i=0;i<dimensione_lista-1;i++){
>       j=i+1;
>       //printf("la distanza tra il punto %d ed il punto %d è:%f\n ",i,j,distanza_tra_due_punti(*lista_di_punti[i],*lista_di_punti[j]));
>
>       perimetro+=distanza_tra_due_punti(*lista_di_punti[i],*lista_di_punti[j]);
>   }
>   //printf("la distanza tra il punto %d ed il punto 0 è:%f\n ",j,distanza_tra_due_punti(*lista_di_punti[j],*lista_di_punti[0]));
>
>   perimetro+= distanza_tra_due_punti(*lista_di_punti[j],*lista_di_punti[0]);
>   return perimetro;
>}
>
>punto ** append(punto ** lista_di_punti,int numero_punti,punto * p){
>   lista_di_punti = realloc(lista_di_punti,numero_punti*sizeof(punto *) );
>   lista_di_punti[numero_punti-1]=p;
>
>   return lista_di_punti;
>}
>
>void stampa_lista_di_punti(punto ** lista_di_punti,int dimensione){
>   printf("lista di punti: [\n");
>   for(int i=0;i<dimensione;i++){
>       stampa_punto(*lista_di_punti[i],"");
>   }
>   printf("]\n");
>}
>
>void stampa_punto(punto p,char * nome_del_punto){
>   printf("%s(%f,%f)\n",nome_del_punto,p.x,p.y);
>}
>
>punto * alloca_punto(float x, float y){
>   punto * p;
>   p=malloc(sizeof(punto));
>
>   p->x=x;
>   p->y=y;
>
>   return p;
>}
>```


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

long long invalid_sum_p1 = 0;
long long invalid_sum_p2 = 0;


void find_invalids_p1(long long r1, long long r2){
    char buff[128];
    char *p1, *p2, *half_start;

    for (long long i = r1; i<= r2; i++){
        sprintf(buff, "%lld", i);
        size_t ln = strlen(buff);
        if (ln % 2 != 0)
            continue;
        //traverse from both ends
        p1 = buff;
        half_start = buff + (ln/2);
        p2 = half_start;
        while (p1 < half_start){
            if (*p1 != *p2)
                break;
            p1 ++;
            p2 ++;
        }
        if (p1 == half_start){
            invalid_sum_p1 += i;
        }
    }
}

void find_invalids_p2(long long r1, long long r2){
    char buff[128];
    for (long long i = r1; i<= r2; i++){
        sprintf(buff, "%lld", i);
        // printf("buff content %s\n",buff);
        size_t ln = strlen(buff);
        //since pattern needs to repeat at least twice for number to be invalid
        int max_substr_len = floor (ln / 2);
        // printf("max substr len %d\n", max_substr_len);
        //for all substring lengths
        for (int j = 1; j < max_substr_len +1 ; j++ ){
            int valid = 0;
            // printf("checking patterns of size %d \n", j);
            //check every jth element
            for(int k = j; k < ln ; k+=j ){
                //compare with the substr
                for(int m = 0; m < j; m++){
                    // printf("comparing index  %d and %d have values %c and %c respectively\n",m, k+m, buff[m], buff[k+m]);
                    if (buff[m] != buff[k+m]){
                        valid = 1;
                    }
                }
            }
            if (!valid){
                invalid_sum_p2 += i;
                // printf("invalid %lld\n",i);
                break;
            }
        }
    }
}

int main(int argc, char** argv) {

    // Character that store the read
    // character
    char ch;
    char tmp;
    char *dash;
    char* buffp;
    char buffer[128], sub1[128], sub2[128];
    int buff_index;
    long long r1, r2;
    // Opening file in reading mode
    FILE *fptr = fopen(argv[1], "r");

    // Reading file character by character
    while (1){
        buffp = buffer;
        while((ch = fgetc(fptr)) != ',' && ch != EOF){
            *buffp = ch;
            if (*buffp == '-')
                dash = buffp ;
            buffp++;
        }
        *buffp = '\0';
        *dash = '\0';
        r1= atoll(buffer);
        r2= atoll(dash + 1 );
        // printf("range %lld-%lld\n", r1,r2);
        find_invalids_p1(r1,r2);
        find_invalids_p2(r1,r2);

        if(ch == EOF)
            break;
    }

    printf("invalid sum p1: %lld p2: %lld \n", invalid_sum_p1, invalid_sum_p2);

    // Closing the file
    fclose(fptr);
    return 0;
}

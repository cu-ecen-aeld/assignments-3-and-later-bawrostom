
#include <stdio.h>
#include<syslog.h>



int main(int argc, char *argv[]){
openlog(NULL,0,LOG_USER);

FILE *file;

char *text=argv[2];

file = fopen(argv[1], "w");
syslog(LOG_INFO,"This is a log info");

if (file == NULL || argc == 0){
printf("There was a problem opening file / or there is an argument missing");
syslog(LOG_ERR,"There was a problem opening file");
return 1;
}
syslog(LOG_DEBUG,"Writing %s to file %s", argv[2], argv[1]);
fprintf(file,"%s\n",text);
//fputs(text,filename);
closelog();
fclose(file);
return 0;
}


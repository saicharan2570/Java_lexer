%{

    #include <string.h>
    #include <stdio.h>
    // #include <>

    int yylex();
    int yyerror(char *s);
    extern FILE *yyin;

    /* Defination */

    int count_dec = 0;
    int count_ques = 0;
    int count_exc = 0;
    int count_para = 0;
    int count_section = 0;
    int count_chapters = 0;
    int count_word = 0;

    char title[100];

    int i = 0;
    char chapter_list[100][100];
    int j = 0;
    char section_list[100][100][100];
    

%}

%union
{
    char* sval;
};

%token<sval> WORD
%token<sval> PUNCTUATION
%token<sval> EXCLAMATION
%token<sval> QUESTION
%token<sval> DECLERATION
%token<sval> TITLE
%token<sval> SECTION
%token<sval> CHAPTER

%token EOL

%%


input:
|   TITLE EOL chapters {strcpy(title, $1);}
;


word: 
     WORD {count_word++;}
;

set_of_words:
    set_of_words PUNCTUATION set_of_words | set_of_words word | word;

sentence:
    set_of_words EXCLAMATION {count_exc++;}
|   set_of_words QUESTION {count_ques++;}
|   set_of_words DECLERATION {count_dec++;}
;

sentences:
    sentences sentence | sentence
;

paragraph:
    sentences EOL {count_para++;} 
;

paragraphs:
    paragraphs paragraph 
    | paragraph
    | paragraph EOL paragraph 
    | paragraph EOL 
    | paragraph paragraph;

section:
   SECTION EOL paragraphs {count_section++;strcpy(section_list[i][j], $1); j++;};

sections:
    sections EOL section | section | section EOL | sections section;

chapter:
    CHAPTER EOL paragraphs {count_chapters++; strcpy(chapter_list[i], $1); i++;}
|   CHAPTER EOL paragraphs sections {count_chapters++; strcpy(chapter_list[i], $1); i++;}
|   CHAPTER EOL paragraphs EOL sections {count_chapters++; strcpy(chapter_list[i], $1); i++;}
|   CHAPTER EOL sections {count_chapters++; strcpy(chapter_list[i], $1); i++;};

chapters:
     chapters EOL chapter | chapter | chapter EOL | chapters chapter;

%%

int main(){

    char str[50];
    printf("Enter the name of input file: ");
    scanf("%s", str);


    FILE * pt = fopen(str, "r" );
    yyin = pt;
    do
    {
        yyparse();
    }while (!feof(yyin));

    FILE * fp  = fopen("output.txt", "w");

/* 
    printf("%s\n", title);

    printf("Number of Chapters: %d\n", count_chapters);
    printf("Number of Sections: %d\n", count_section);
    printf("Number of Paragraphs: %d\n", count_para);
    printf("Number of Declerative Sentences: %d\n", count_dec);
    printf("Number of Exclamatory Sentences: %d\n", count_exc);
    printf("Number of Interogative Sentences: %d\n", count_ques);
    printf("Number of Sentences: %d\n", count_dec + count_exc + count_ques);
    printf("Number of Words: %d\n", count_word);

    for(int k = 0;k<count_chapters;k++)
        {
            printf("%s\n", chapter_list[k]);

            for(int t = 0;t<100;t++)
            {
                if(section_list[k][t][0] != '\0')
                {
                    printf("%s\n", section_list[k][t]);
                }
            }

        } */

    fprintf(fp,"%s\n", title);
    fprintf(fp,"Number of Chapters: %d\n", count_chapters);
    fprintf(fp,"Number of Sections: %d\n", count_section);
    fprintf(fp,"Number of Paragraphs: %d\n", count_para);
    fprintf(fp,"Number of Declerative Sentences: %d\n", count_dec);
    fprintf(fp,"Number of Exclamatory Sentences: %d\n", count_exc);
    fprintf(fp,"Number of Interogative Sentences: %d\n", count_ques);
    fprintf(fp,"Number of Sentences: %d\n", count_dec + count_exc + count_ques);
    fprintf(fp,"Number of Words: %d\n", count_word);

    for(int k = 0;k<count_chapters;k++)
        {
            fprintf(fp, "%s\n", chapter_list[k]);

            for(int t = 0;t<100;t++)
            {
                if(section_list[k][t][0] != '\0')
                {
                    fprintf(fp, "%s\n", section_list[k][t]);
                }
            }

        }

    


    return 0;
}


int yyerror(char* s){
    printf("ERROR: %s\n", s);

    return 0;
}

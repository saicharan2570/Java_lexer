%{
#include <bits/stdc++.h>
 #include <utility>
#include <fstream>
using namespace std;

 map<string,int>m;
 map<string,string>v;
 vector<string>S;
 int line_num=1;
 int nothing=0;


	
%}
HexDig    [0][x][0-9a-fA-F]+
DN        [0]|[1-9][0-9]*

B         [0][bB][01]+
ID        [a-zA-Z][a-zA-Z0-9_]*
CHAR      [a-mo-zA-Z]
DQ        ["]
SPACE     [ ]*
Semicolon  ;
R         "return"
N         "null"
Triple    ["]{3}

  
       
%%


"/*"    {
        int c;

        while((c = yyinput()) != 0)
            {
            if(c == '\n')
                ++line_num;

            else if(c == '*')
                {
                if((c = yyinput()) == '/')
                    break;
                else
                    unput(c);
                }
            }
        }

"/"{2}  {
	    int c;
	    c=yyinput();
           while((c=yyinput())!=0)
           {
           	if(c=='\n')
           	{
           		break;
           	}
           }
	    }
	    
	    
"'"[^\'\n\\]"'" {
              
               string s=yytext;
                                  if(m[s]==0)
                                  {
                                    S.push_back(s);
                                    m[s]++;
                                    v[s]="Character"; 
                                  }
                                  else
                                  {
                                    m[s]++;
                                  }

}

[ \t]+

\n   {++line_num;
         }

{Triple}(.*?|\n)*?{Triple} {  
                   


                     string s=yytext;
                                  if(m[s]==0)
                                  {
                                    S.push_back(s);
                                    m[s]++;
                                    v[s]="TextBlock"; 
                                  }
                                  else
                                  {
                                    m[s]++;
                                  }

                                  line_num+=3;


}
 {N}   {

         string s=yytext;
                                  if(m[s]==0)
                                  {
                                    S.push_back(s);
                                    m[s]++;
                                    v[s]="Null Literal"; 
                                  }
                                  else
                                  {
                                    m[s]++;
                                  }

} 

abstract|continue|for|new|switch|assertdefault|if|package|synchronized|boolean|do|goto|private|this|break|double|implements|protected|throw|byte|else|import|public|throws|case|enum|instanceof|return|transient|catch|extends|int|short|try|char|final|interface|static|void|class|finally|long|strictfp|volatile|const|float|native|super|while|_|exports|opens|requires|uses|module|permits|sealed|var|non-sealed|provides|to|with|open|record|transitive|yield  {

                            string s=yytext;
                                  if(m[s]==0)
                                  {
                                  	S.push_back(s);
                                  	m[s]++;
                                  	v[s]="Keyword"; 
                                  }
                                  else
                                  {
                                  	m[s]++;
                                  }



}


{ID}      {

                   string s=yytext;
                                  if(m[s]==0)
                                  {
                                    S.push_back(s);
                                    m[s]++;
                                    v[s]="Identifier"; 
                                  }
                                  else
                                  {
                                    m[s]++;
                                  }
                                 
                     }

([1-9]+|"0"[xX][0-9a-fA-F]+|"0"[bB][01]+)[lLfFdD]?|"0"[xX][0-9a-fA-F]*"."[0-9a-fA-F]+[pP][+-]?[0-9]*[fFdD]?|"0"[xX][0-9a-fA-F]"."[0-9a-fA-F]*[pP][+-]?[0-9]*[fFdD]?|[0-9]+"."[0-9]*[eE][+-]?[0-9]+[fFdD]?|[0-9]*"."[0-9]+[eE][+-]?[0-9][fFdD]?|[0-9]*"."[0-9]+[fFdD]?|[0-9]+"."[0-9]*[fFdD]?|[0]+[1-7]*[fFdDlL]?    {

     string s=yytext;
                                  if(m[s]==0)
                                  {
                                    S.push_back(s);
                                    m[s]++;
                                    v[s]="Literal"; 
                                  }
                                  else
                                  {
                                    m[s]++;
                                  }

}
                  


                     






"("|"{"|"}"|"["|"]"|{Semicolon}|"."|"..."|"@"|"::"|")"|","    {


	                              string s=yytext;
                                  if(m[s]==0)
                                  {
                                  	S.push_back(s);
                                  	m[s]++;
                                  	v[s]="Separator"; 
                                  }
                                  else
                                  {
                                  	m[s]++;
                                  }
}

{DQ}[^}\n]*{DQ} {

	            string s=yytext;
                                  if(m[s]==0)
                                  {
                                  	S.push_back(s);
                                  	m[s]++;
                                  	v[s]="String"; 
                                  }
                                  else
                                  {
                                  	m[s]++;
                                  }
                                 

}


"="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"="|"^="|"%="|"<<="|">>="|">>>="    { 
                                  
                                  string s=yytext;
                                  if(m[s]==0)
                                  {
                                  	S.push_back(s);
                                  	m[s]++;
                                  	v[s]="Operator"; 
                                  }
                                  else
                                  {
                                  	m[s]++;
                                  }
                                 
                                  }
.           {cout<<yytext<<" "<<"IS AN ILLEGAL CHARACTER  IN LINE"<<" "<< line_num<< endl; 
                   
               }                                  

%%
int yywrap(){return 1;}
int main(int argc, char **argv){
 

yyin=fopen(argv[1],"r");
 yylex();

 ofstream csvFile("Result.csv");
 csvFile<<"LEXEME"<<","<<"TOKEN"<<","<<"COUNT"<<endl;

vector<string>::iterator it=S.begin();
    while(it!=S.end())
    {
           csvFile<< (*it) << "," << v[(*it)]<<","<<m[(*it)]<<endl;
            it++;    
    }
    

 
fclose(yyin);


return 0;
}